import { CreatedTripSchema, GeoPointSchema, RouteSchema, ScheduleTripSchema } from "./schema";
import * as admin from 'firebase-admin'
import { FirestoreKey, RealtimeKey } from '../../constants'
import { autoID } from "../utils/misc";
import { _documentWithOptions } from "firebase-functions/lib/providers/firestore";
import { Route } from "../../models-shared/route";


export interface TripDAOInterface {


    /**
     * 
     * @param data 
     * @returns The id of the trip document.
     */
    createAddedTrip(id: string, data: CreatedTripSchema): Promise<string>

    getDriverTrips(driverID: string): Promise<CreatedTripSchema[]>

    getRiderTrips(riderID: string): Promise<CreatedTripSchema[]>

    /**
    * Creates a set of points in the database and associates each with a geo hash which can be used to query trips that pass through a certain geohashed area.
    * @param points A list of points of the route. Must be in order based on the of the route.
    * @param tripID The record id associated with a created trip.
    */
    addGeoPoints(points: GeoPointSchema[]): Promise<void>

    /**
     * Removes all geopoints associated with the route of a trip.
     * @param tripID The record id associated with a created trip.
     * @returns An array of the delete points.
     */
    removeGeoPoints(tripID: string): Promise<GeoPointSchema[]>

    getGeoPointsByTripID(tripID: string): Promise<GeoPointSchema[]>

    getGeoPointsByHash(hash: string): Promise<GeoPointSchema[]>

    /**
     * Stores the route data so it can be retrieved later without needing to call the Google API.
     * @param tripID The document id of the trip the given route is associated with.
     * @param cacheID An id generated derived from start, end, and waypoints points the route passes through.
     * @param route A route object.
     */
    cacheRoute(tripID: string, cacheID: string, route: Route): Promise<void>

    /**
     * Gets routes stored for a certain trip.
     * @param tripID The document id of the trip the given route is associated with.
     * @param waypoints The number of waypoints the route has to narrow down the results.
     */
    getCachedRoutes(tripID: string, waypoints?: number): Promise<Route[]>

    updateCreatedTrip(tripID: string, data: Partial<CreatedTripSchema>): Promise<void>

    getCreatedTrip(tripID: string): Promise<CreatedTripSchema>

    getDriverCompletedTrips(driverID: string): Promise<ScheduleTripSchema[]>

    getRiderCompletedTrips(riderID: string): Promise<ScheduleTripSchema[]>
}

export class TripDAO implements TripDAOInterface {

    db: admin.firestore.Firestore

    realtimeDB: admin.database.Database

    constructor(db: admin.firestore.Firestore, realtimeDB: admin.database.Database) {
        this.db = db
        this.realtimeDB = realtimeDB
    }

    async cacheRoute(tripID: string, cacheID: string, route: Route): Promise<void> {
        const data: RouteSchema = {
            waypointOrder: route.waypointOrder,
            tripID: tripID,
            legs: route.legs,
            distance: route.distance,
            duration: route.duration,
            polyline: route.polyline
        }
        await this.db.collection(FirestoreKey.cachedRoutes).doc(cacheID).create(data)
    }


    getCachedRoutes(tripID: string, waypoints?: number): Promise<Route[]> {
        let query = this.db.collection(FirestoreKey.cachedRoutes)
            .where('tripID', '==', tripID)

        if (waypoints !== undefined) {
            query = query.where('waypointCount', '==', waypoints)
        }
        return query.get().then(snap => {
            return snap.docs.map(doc => {
                const r = doc.data() as RouteSchema
                return new Route(r.waypointOrder, r.polyline, r.legs, r.distance, r.duration)
            })
        })

    }

    async addGeoPoints(points: GeoPointSchema[]): Promise<void> {

        const data: Record<string, any> = {}

        points.forEach((p, i) => {
            data[`${RealtimeKey.tripPoints}/${autoID()}`] = p
        })

        await this.realtimeDB.ref().update(data) //NOTE: Using multi-location update only works with .update() and not .set() 
    }

    getGeoPointsByTripID(tripID: string): Promise<GeoPointSchema[]> {
        return new Promise<GeoPointSchema[]>(async (resolve, reject) => {
            await this.realtimeDB.ref(RealtimeKey.tripPoints).orderByChild('tripID').equalTo(tripID).once('value', (async snapshot => {
                const points: GeoPointSchema[] = []
                snapshot.forEach(child => {
                    points.push(child.val())
                })
                resolve(points)
            }), (err) => {
                reject(err)
            })
        })
    }

    getGeoPointsByHash(hash: string): Promise<GeoPointSchema[]> {
        return new Promise<GeoPointSchema[]>(async (resolve, reject) => {
            await this.realtimeDB.ref(RealtimeKey.tripPoints).orderByChild('hash').equalTo(hash).once('value', (async snapshot => {
                const points: GeoPointSchema[] = []
                snapshot.forEach(child => {
                    points.push(child.val())
                })
                resolve(points)
            }), (err) => {
                reject(err)
            })
        })
    }

    removeGeoPoints(tripID: string): Promise<GeoPointSchema[]> {
        return new Promise<GeoPointSchema[]>(async (resolve, reject) => {
            await this.realtimeDB.ref(RealtimeKey.tripPoints).orderByChild('tripID').equalTo(tripID).once('value', (async snapshot => {
                const points: GeoPointSchema[] = []
                const toDelete: Record<string, any> = {}
                snapshot.forEach(child => {
                    points.push(child.val())
                    toDelete[`${RealtimeKey.tripPoints}/${child.key}`] = null
                })
                await this.realtimeDB.ref().update(toDelete)
                resolve(points)
            }), (err) => {
                reject(err)
            })
        })
    }

    async createAddedTrip(docID: string, data: CreatedTripSchema): Promise<string> {
        const tripRef = this.db.collection(FirestoreKey.tripsCreated).doc(docID)
        await tripRef.create(data)
        return tripRef.id
    }


    //HERE Promise<CreatedTripSchema[]
    async getDriverTrips(driverID: string): Promise<CreatedTripSchema[]> {
        const snapshot = await this.db.collection(FirestoreKey.tripsCreated).where('driverID', '==', driverID).get()

        const now = new Date().getTime()
        return (snapshot.docs.map(doc => doc.data()) as CreatedTripSchema[]).filter(t => t.startTime.toDate().getTime() > now)
    }


    async getRiderTrips(riderID: string): Promise<CreatedTripSchema[]> {

        const scheduledRides = await this.db.collection(FirestoreKey.tripsCreated)
            .where(`riderStatus.${riderID}`, 'in', ['Requested', 'Accepted'])
            .get()

        const now = new Date().getTime()
        return (scheduledRides.docs.map(doc => doc.data()) as CreatedTripSchema[]).filter(t => t.startTime.toDate().getTime() > now)
    }

    async updateCreatedTrip(tripID: string, data: Partial<CreatedTripSchema>): Promise<void> {
        await this.db.collection(FirestoreKey.tripsCreated).doc(tripID).update(data)
    }

    getCreatedTrip(tripID: string): Promise<CreatedTripSchema> {
        return this.db.collection(FirestoreKey.tripsCreated).doc(tripID)
            .get().then(doc => doc.data() as CreatedTripSchema)
    }

    async getDriverCompletedTrips(driverID: string): Promise<ScheduleTripSchema[]> {
        const completedTrips = await this.db.collection(FirestoreKey.tripsScheduled).where('driverID','==',`${driverID}`).where('tripStatus','==','COMPLETED').get()

        return completedTrips.docs.map(doc => doc.data()) as ScheduleTripSchema[]
    }

    async getRiderCompletedTrips(riderID: string): Promise<ScheduleTripSchema[]> {

         const completedTrips = await this.db.collection(FirestoreKey.tripsScheduled).where(`riderStatus.${riderID}`,'==','COMPLETED').get()
        return completedTrips.docs.map(doc =>doc.data()) as ScheduleTripSchema[]

    }



}
