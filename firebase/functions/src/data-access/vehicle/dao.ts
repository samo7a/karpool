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

    // async updateVehicle(data: VehicleSchema): Promise<void>{
    //     const driver = this.db.collection(FirestoreKey.users).doc(data.uid)
    //     await driver.update(fireEncode(data))
    // }

}



