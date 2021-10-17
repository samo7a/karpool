import { CreatedTripSchema, GeoPointSchema, ScheduleTripSchema } from "./schema";
import * as admin from 'firebase-admin'
import { FirestoreKey, RealtimeKey } from '../../constants'
import { autoID } from "../utils/misc";
import { HttpsError } from "firebase-functions/lib/providers/https";


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

    updateCreatedTrip(tripID: string, data: Partial<CreatedTripSchema>): Promise<void>

    getCreatedTrip(tripID: string): Promise<CreatedTripSchema>

    getDriverCompletedTrips(driverID: string): Promise<ScheduleTripSchema[]>

    getRiderCompletedTrips(riderID: string): Promise<ScheduleTripSchema[]>

    //  riderRequestTrip(tripID: string,  riderID: string): Promise<void>

    deleteCreatedTrip(docID: string): Promise<void>


    createScheduledTrip(tripID: string, data: ScheduleTripSchema): Promise<string>

    getSchedulededTrip(tripID: string): Promise<ScheduleTripSchema>

    updateScheduledTrip(tripID: string, data: Partial<ScheduleTripSchema>): Promise<void>

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

    //TODO: Throw error if function.
    async getCreatedTrip(tripID: string): Promise<CreatedTripSchema> {
        const doc = await this.db.collection(FirestoreKey.tripsCreated).doc(tripID).get()
        if (!doc.exists) {
            throw new HttpsError('not-found', `Trip with id: ${tripID} not found.`)
        } else {
            return doc.data() as CreatedTripSchema
        }

    }

    async getDriverCompletedTrips(driverID: string): Promise<ScheduleTripSchema[]> {
        const completedTrips = await this.db.collection(FirestoreKey.tripsScheduled).where('driverID', '==', `${driverID}`).where('tripStatus', '==', 'COMPLETED').get()

        return completedTrips.docs.map(doc => doc.data()) as ScheduleTripSchema[]
    }

    async getRiderCompletedTrips(riderID: string): Promise<ScheduleTripSchema[]> {

        const completedTrips = await this.db.collection(FirestoreKey.tripsScheduled).where(`riderStatus.${riderID}`, '==', 'COMPLETED').get()
        return completedTrips.docs.map(doc => doc.data()) as ScheduleTripSchema[]

    }

    async deleteCreatedTrip(docID: string): Promise<void> {
        await this.db.collection(FirestoreKey.tripsCreated).doc(docID).delete()
    }

    // async riderRequestTrip(tripID: string,  riderID: string): Promise<void>{
    //     await this.db.collection(FirestoreKey.tripsCreated).doc(tripID).
    //     //.set({riderStatus:riderID,'Requested'})
    //     //this.db.collection(FirestoreKey.tripsCreated).doc(tripID).update({'riderStatus':FieldValue.arrayUnion([riderID,'Requested'])})

    // }


    async createScheduledTrip(tripID: string, data: ScheduleTripSchema): Promise<string>{
        const scheduledTripRef = this.db.collection(FirestoreKey.tripsScheduled).doc(tripID)
        await scheduledTripRef.create(data)
        return scheduledTripRef.id
    }

    async updateScheduledTrip(tripID: string, data: Partial<ScheduleTripSchema>): Promise<void> {
        await this.db.collection(FirestoreKey.tripsScheduled).doc(tripID).update(data)
    }

    async getSchedulededTrip(tripID: string): Promise<ScheduleTripSchema>{
        const doc = await this.db.collection(FirestoreKey.tripsScheduled).doc(tripID).get()
        if (!doc.exists) {
            throw new HttpsError('not-found', `Trip with id: ${tripID} not found.`)
        } else {
            return doc.data() as ScheduleTripSchema
        }
    }

}
