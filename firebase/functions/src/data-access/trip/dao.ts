import { CreatedTripSchema } from "./schema";
import * as admin from 'firebase-admin'
import { FirestoreKey } from '../../constants'

export interface TripDAOInterface {


    /**
     * 
     * @param data 
     * @returns The id of the trip document.
     */
    createAddedTrip(data: CreatedTripSchema): Promise<string>

    getTrips(driverID: string): Promise<CreatedTripSchema[]>



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


    
    getTrips(driverID: string): Promise<CreatedTripSchema[]> {
        throw new Error("Method not implemented.");
    }

}