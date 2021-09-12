import { CreatedTripSchema } from "./schema";
import * as admin from 'firebase-admin'
import { FirestoreKey } from '../../constants'
//import { fireDecode } from "../utils/decode";
//import { TripService } from "../../features/trip/trip-service";

export interface TripDAOInterface {


    /**
     * 
     * @param data 
     * @returns The id of the trip document.
     */
    createAddedTrip(data: CreatedTripSchema): Promise<string>

    getDriverTrips(driverID: string): Promise<CreatedTripSchema[]>



}

export class TripDAO implements TripDAOInterface {

    db: admin.firestore.Firestore

    constructor(db: admin.firestore.Firestore) {
        this.db = db
    }

   async createAddedTrip(data: CreatedTripSchema): Promise<string> {
        const tripRef = this.db.collection(FirestoreKey.trips).doc()
        await tripRef.create(data)
        return "Trip Added successfully!!"
        //throw new Error("Method not implemented.");
    }


    //HERE Promise<CreatedTripSchema[]
    async getDriverTrips(driverID: string): Promise<CreatedTripSchema[]> {
        const snapshot = await this.db.collection(FirestoreKey.trips).where('driverID','==',driverID).get()
        return snapshot.docs.map(doc => doc.data()) as CreatedTripSchema[]
    }
 
}
