import { CreatedTripSchema } from "./schema";
import * as admin from 'firebase-admin'
import { FirestoreKey } from '../../constants'
import { fireEncode } from "../utils/encode";


export interface TripDAOInterface {


    /**
     * 
     * @param data 
     * @returns The id of the trip document.
     */
    createAddedTrip(data: CreatedTripSchema): Promise<string>

    getDriverTrips(driverID: string): Promise<CreatedTripSchema[]>

    getRiderTrips(riderID: string): Promise<CreatedTripSchema[]>

    updateCreateTrip(tripID: string, closure: (data: CreatedTripSchema) => CreatedTripSchema ): Promise<void>

}

export class TripDAO implements TripDAOInterface {

    db: admin.firestore.Firestore

    constructor(db: admin.firestore.Firestore) {
        this.db = db
    }
    //Function to add new trips by the driver
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


    async getRiderTrips(riderID: string): Promise<CreatedTripSchema[]>{

        const scheduledRides = await this.db.collection(FirestoreKey.trips).where(`riderStatus.${riderID}`, 'in', ['Requested', 'Accepted']).get()

        return scheduledRides.docs.map(doc => doc.data()) as CreatedTripSchema[]
    }


    async updateCreateTrip(tripID: string, closure: (data: CreatedTripSchema) => CreatedTripSchema ): Promise<void> {

    const docReference = this.db.collection(FirestoreKey.trips).doc(tripID)

       await this.db.runTransaction(async transaction => {
           const trip = await transaction.get(docReference).then(doc => doc.data()) as CreatedTripSchema
           const newTrip = closure(trip)
          return transaction.update(docReference, fireEncode(newTrip))
       })

    }
 
}
