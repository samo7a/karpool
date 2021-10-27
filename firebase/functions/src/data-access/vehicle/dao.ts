import * as admin from 'firebase-admin'
import { HttpsError } from 'firebase-functions/v1/https';
import { FirestoreKey } from '../../constants';
import { RecursivePartial } from '../../features/account-management/cloud-functions';
import { fireEncode } from '../utils/encode';

import { VehicleSchema } from "./types";


export interface VehicleDAOInterface {

    setVehicle(id: string, data: VehicleSchema): Promise<void>

    getVehicle(driverID: string): Promise<{ id: string, vehicle: VehicleSchema }>

    updateVehicle(id: string, data: Partial<VehicleSchema>): Promise<void>

    deleteVehicle(id: string): Promise<void>
}


export class VehicleDAO implements VehicleDAOInterface {

    private db: admin.firestore.Firestore

    constructor(db: admin.firestore.Firestore) {
        this.db = db
    }

    async setVehicle(id: string, data: VehicleSchema): Promise<void> {
        await this.db.collection(FirestoreKey.vehicles).doc(id).set(fireEncode(data))
    }


    async updateVehicle(id: string, data: RecursivePartial<VehicleSchema>): Promise<void> {
        const driver = this.db.collection(FirestoreKey.users).doc(id)
        await driver.update(fireEncode(data))
    }

    getVehicle(driverID: string): Promise<{ id: string, vehicle: VehicleSchema }> {

        return this.db.collection(FirestoreKey.vehicles).doc(driverID).get().then(doc => {
            if (doc.exists) {
                return { id: doc.id, vehicle: doc.data()! as VehicleSchema }
            } else {
                return Promise.reject(new HttpsError('not-found', `Vehicle for id: ${driverID} not found.`))
            }
        })

    }

    async deleteVehicle(id: string): Promise<void> {
        await this.db.collection(FirestoreKey.vehicles).doc(id).delete()
    }


}



