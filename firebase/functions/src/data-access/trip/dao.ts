import { CreatedTripSchema, GeoPointSchema } from "./schema";
import * as admin from 'firebase-admin'
import { FirestoreKey, RealtimeKey } from '../../constants'
//import { fireDecode } from "../utils/decode";
//import { TripService } from "../../features/trip/trip-service";
import { autoID } from "../utils/misc";

export interface TripDAOInterface {


    /**
     * 
     * @param data 
     * @returns The id of the trip document.
     */
    createAddedTrip(data: CreatedTripSchema): Promise<string>

    getDriverTrips(driverID: string): Promise<CreatedTripSchema[]>


    addGeoPoints(points: GeoPointSchema[]): Promise<void>

    removeGeoPoints(tripID: string): Promise<GeoPointSchema[]>


}

export class TripDAO implements TripDAOInterface {

    db: admin.firestore.Firestore

    realtimeDB: admin.database.Database

    constructor(db: admin.firestore.Firestore, realtimeDB: admin.database.Database) {
        this.db = db
        this.realtimeDB = realtimeDB
    }


    /**
     * Creates a set of points in the database and associates each with a geo hash which can be used to query trips that pass through a certain geohashed area.
     * @param points A list of points of the route. Must be in order based on the of the route.
     * @param tripID The record id associated with a created trip.
     */
    async addGeoPoints(points: GeoPointSchema[]): Promise<void> {

        const data: Record<string, any> = {}

        points.forEach((p, i) => {
            data[`${RealtimeKey.tripPoints}/${autoID()}`] = p
        })

        await this.realtimeDB.ref().update(data) //NOTE: Using multi-location update only works with .update() and not .set() 
    }


    /**
     * Removes all geopoints associated with the route of a trip.
     * @param tripID The record id associated with a created trip.
     * @returns An array of the delete points.
     */
    removeGeoPoints(tripID: string): Promise<GeoPointSchema[]> {
        return new Promise<GeoPointSchema[]>((resolve, reject) => {
            this.realtimeDB.ref(RealtimeKey.tripPoints).orderByChild('tripID').equalTo(tripID).once('value', (async snapshot => {
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
        return "Trip Added successfully!!"
        //throw new Error("Method not implemented.");
    }


    //HERE Promise<CreatedTripSchema[]
    async getDriverTrips(driverID: string): Promise<CreatedTripSchema[]> {
        const snapshot = await this.db.collection(FirestoreKey.tripsCreated).where('driverID', '==', driverID).get()
        return snapshot.docs.map(doc => doc.data()) as CreatedTripSchema[]
    }



}
