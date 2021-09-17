import { CreatedTripSchema, GeoPointSchema } from "./schema";
import * as admin from 'firebase-admin'
import { FirestoreKey, RealtimeKey } from '../../constants'
import { autoID } from "../utils/misc";


export interface TripDAOInterface {


    /**
     * 
     * @param data 
     * @returns The id of the trip document.
     */
    createAddedTrip(data: CreatedTripSchema): Promise<string>

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

    updateCreatedTrip(tripID: string, data: Partial<CreatedTripSchema>): Promise<void>

    getCreatedTrip(tripID: string): Promise<CreatedTripSchema>

}

export class TripDAO implements TripDAOInterface {

    db: admin.firestore.Firestore

    realtimeDB: admin.database.Database

    constructor(db: admin.firestore.Firestore, realtimeDB: admin.database.Database) {
        this.db = db
        this.realtimeDB = realtimeDB
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

    async createAddedTrip(data: CreatedTripSchema): Promise<string> {
        const tripRef = this.db.collection(FirestoreKey.tripsCreated).doc()
        await tripRef.create(data)
        return tripRef.id
    }


    //HERE Promise<CreatedTripSchema[]
    async getDriverTrips(driverID: string): Promise<CreatedTripSchema[]> {
        const snapshot = await this.db.collection(FirestoreKey.tripsCreated).where('driverID', '==', driverID).get()
        return snapshot.docs.map(doc => doc.data()) as CreatedTripSchema[]
    }


    async getRiderTrips(riderID: string): Promise<CreatedTripSchema[]> {

        const scheduledRides = await this.db.collection(FirestoreKey.tripsCreated).where(`riderStatus.${riderID}`, 'in', ['Requested', 'Accepted']).get()

        return scheduledRides.docs.map(doc => doc.data()) as CreatedTripSchema[]
    }

    async updateCreatedTrip(tripID: string, data: Partial<CreatedTripSchema>): Promise<void> {
        await this.db.collection(FirestoreKey.tripsCreated).doc(tripID).update(data)
    }

    getCreatedTrip(tripID: string): Promise<CreatedTripSchema> {
        return this.db.collection(FirestoreKey.tripsCreated).doc(tripID)
            .get().then(doc => doc.data() as CreatedTripSchema)
    }

}
