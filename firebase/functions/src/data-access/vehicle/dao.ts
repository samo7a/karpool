import * as admin from 'firebase-admin'
import { HttpsError } from 'firebase-functions/lib/providers/https'
import { FirestoreKey } from '../../constants';
import { DeepPartial } from '../../utils/types'
import { fireEncode } from '../utils/encode';

import { VehicleSchema } from "./types";

export interface VehicleDAOInterface {

    setVehicle(id: string, data: VehicleSchema): Promise<void>

    getVehicle(driverID: string): Promise<{ id: string, vehicle: VehicleSchema }>

    updateVehicle(uid: string, data: VehicleSchema): Promise<void>

    //Edit Vehicle
    //Delete vehicle

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


    async updateVehicle(id: string, data: DeepPartial<VehicleSchema>): Promise<void> {
        const nestedData: Partial<VehicleSchema> = {
            color: data.color,
            licensePlateNum: data.licensePlateNum,
            make: data.make,
            year: data.year
        }
        const castedData: Record<string, any> = nestedData
        //Need to use dot notation for these or some fields may get overwritten.
        castedData['insurance.provider'] = data.insurance?.provider
        castedData['insurance.coverageType'] = data.insurance?.coverageType
        castedData['insurance.startDate'] = data.insurance?.startDate
        castedData['insurance.endDate'] = data.insurance?.endDate

        await this.db.collection(FirestoreKey.vehicles).doc(id).update(castedData)
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



