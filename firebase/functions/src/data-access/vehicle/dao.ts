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

    updateVehicle(uid: string, data: VehicleSchema): Promise<void>

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


    async updateVehicle(uid: string, data: Partial<VehicleSchema>): Promise<void>{
        const driver = this.db.collection(FirestoreKey.users).doc(uid)
        await driver.update(fireEncode(data))
    }

    async getVehicle(driverID: string): Promise<string>{

        const car = await this.db.collection(FirestoreKey.vehicles).where('uid', '==', driverID).get()
            
        return car.docs[0].id

    }



}



