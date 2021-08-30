

import * as admin from 'firebase-admin'
import { FirestoreEncoder } from '../firestore-encoder'
import { FirestoreKey } from '../../constants'
import { UserSchema } from './schema'
import { UserCreationInfo, Role } from './types'
import { User } from '../../models-shared/user'
import { decodeDoc } from '../utils'

/**
 * Since other functionality may depend on this, we'll use an interface so we can make a mock later
 * for unit testing.
*/
export interface UserDAOInterface {

    /**
     * Creates a user document to hold the user's account information.
     * Throws an error if a user document already exists under the given uid.
     * @param uid The user's id.
     * @param info A user schema object.
     */
    createUserInfo(uid: string, info: UserCreationInfo): Promise<void>

    /**
     * Updates only the fields provided in the fields parameter. All other fields will be left unmodified.
     * NOTE: This method uses the a database schema directly. If the database schema changes, we can make
     * a new interface type that uses the same props as the old schema and map it to the new one.
     * @param uid The user's id.
     * @param fields Fields to update in the user document.
     */
    updateUserInfo(uid: string, fields: Partial<UserSchema>): Promise<void>

    /**
     * Gets a user's data as a User class instance given a uid.
     * @param uid The user's id.
     */
    getUserInfo(uid: string): Promise<User>

    /**
     * Deletes a user's document.
     * This method should only be called when a user has "deleted" both their driver and rider information.
     * @param uid The user's id.
     */
    deleteUserInfo(uid: string): Promise<void>

    /**
     * Deletes all rider information associated with a user account. 
     * This method should only be called when a user is "deleting" their rider account.
     * @param uid The user's id.
     */
    deleteRiderInfo(uid: string): Promise<void>

    /**
     * Deletes all driver information associated with a user's account.
     * This method should only be called when a user is "deleting" their driver account.
     * @param uid The user's id.
     */
    deleteDriverInfo(uid: string): Promise<void>

}


/**
 * A DAO for communicating with the database. The purpose of this class is to decouple the database 
 * implementation from the other business logic code.
 * https://softwareengineering.stackexchange.com/a/220917
 */
export class UserDAO implements UserDAOInterface {

    db: admin.firestore.Firestore

    constructor(db: admin.firestore.Firestore) {
        this.db = db
    }

    async createUserInfo(uid: string, info: UserCreationInfo): Promise<void> {
        const roles: Partial<Record<Role, boolean>> = {}

        if (info.driverInfo) {
            roles['Driver'] = true
        }
        if (info.riderInfo) {
            roles['Rider'] = true
        }

        const data: UserSchema = {
            firstName: info.firstName,
            lastName: info.lastName,
            phone: info.phone,
            email: info.email,
            gender: info.gender,
            dob: info.dob,
            address: info.address,
            joinDate: new Date(),
            roles: roles,
            driverInfo: info.driverInfo,
            riderInfo: info.riderInfo,
            profileURL: undefined
        }
        const userRef = this.db.collection(FirestoreKey.users).doc(uid)
        await userRef.create(data)
    }

    async updateUserInfo(uid: string, fields: Partial<UserSchema>): Promise<void> {
        const userRef = this.db.collection(FirestoreKey.users).doc(uid)
        const data = new FirestoreEncoder().encode(fields)
        await userRef.update(data)
    }

    async getUserInfo(uid: string): Promise<User> {
        const userRef = this.db.collection(FirestoreKey.users).doc(uid)
        return userRef.get().then(doc => decodeDoc(User, doc))
    }

    async deleteUserInfo(uid: string): Promise<void> {
        const userRef = this.db.collection(FirestoreKey.users).doc(uid)
        await userRef.delete()
    }


    deleteRiderInfo(uid: string): Promise<void> {
        /**
                * Set isRider flag to false
                * Delete rider reviews
                * 
                */
        return Promise.reject(new Error('Unimplemented.'))
    }

    deleteDriverInfo(uid: string): Promise<void> {
        /**
               * delete drivers licenseNum
               * delete vehicle ID
               * delete vehicle
               * set isDriver flag to false
               * delete banking information
               * Delete driver reviews
               */
        return Promise.reject(new Error('Unimplemented.'))
    }

    /*TODO: Change this to get trips and use the service class for earnings.
    async getEarnings(driverID: string, startDate: Date, endDate: Date): Promise<number> {

        return this.db.collection('trips')
            .where('driverID', '==', driverID)
            .where('date', '>', startDate)
            .where('date', '<', endDate)
            .get()
            .then(snapshot => {
                return snapshot.docs.map(doc => {
                    return doc.data() as Trip
                })
            }).then(trips => {
                let sum: number = 0
                trips.forEach(trip => {
                    sum += trip.totalFairs
                })
                return sum
            })
    }
    */


}