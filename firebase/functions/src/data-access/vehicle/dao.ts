import * as admin from 'firebase-admin'
import { FirestoreKey } from '../../constants';
import { fireEncode } from '../utils/encode';

import { VehicleSchema } from "./types";


export interface VehicleDAOInterface {

    //Create vehicle

    /**
     * This function creates a vehicle in the vehicles table.
     * @param data 
     */
    createVehicle(data: VehicleSchema): Promise<void>

    getVehicle(driverID: string): Promise <string>


    //Edit Vehicle
    //Delete vehicle

}


export class VehicleDAO implements VehicleDAOInterface {

    private db: admin.firestore.Firestore

    constructor(db: admin.firestore.Firestore) {
        this.db = db
    }

    async createVehicle(data: VehicleSchema): Promise<void> {
        await this.db.collection(FirestoreKey.vehicles).doc().create(fireEncode(data))
    }

    async getVehicle(driverID: string): Promise<string>{

        const car = await this.db.collection(FirestoreKey.vehicles).where('uid', '==', driverID).get()
            
        return car.docs[0].id

    }


}
