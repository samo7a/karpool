

import * as admin from 'firebase-admin'
import { FirestoreKey } from '../../constants'
import { UserSchema, tokenSchema, earnings } from './schema'
import { Role } from './types'
import { User } from '../../models-shared/user'
import { fireDecode } from '../utils/decode'
import { fireEncode } from '../utils/encode'
import { HttpsError } from 'firebase-functions/lib/providers/https'
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
    createAccountData(uid: string, info: UserSchema): Promise<void>

    /**
     * Updates only the fields provided in the fields parameter. All other fields will be left unmodified.
     * NOTE: This method uses the a database schema directly. If the database schema changes, we can make
     * a new interface type that uses the same props as the old schema and map it to the new one.
     * @param uid The user's id.
     * @param fields Fields to update in the user document.
     */
    updateAccountData(uid: string, fields: Partial<UserSchema>): Promise<void>

    /**
     * Gets a user's data as a User class instance given a uid.
     * @param uid The user's id.
     */
    getAccountData(uid: string): Promise<User>

    /**
     * Deletes a user's document.
     * This method should only be called when a user has "deleted" both their driver and rider information.
     * @param uid The user's id.
     */
    deleteAccountData(uid: string): Promise<void>


    updateUserAccount(uid: string, info: UserSchema | Partial<UserSchema>): Promise<void>

    storeUserDeviceToken(uid: string, data: tokenSchema): Promise<void>

    updateDeviceTokenList(uid: string, data: tokenSchema): Promise<void>

    getAllEarnings(uid: string): Promise<earnings[]>

    getEarningsByMonth(uid: string, start: string, end: string): Promise<number>
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

    //MARK: User Methods

    async createAccountData(uid: string, info: UserSchema): Promise<void> {
        const roles: Partial<Record<Role, boolean>> = {}

        if (info.driverInfo) {
            roles['Driver'] = true
        }
        if (info.riderInfo) {
            roles['Rider'] = true
        }

        const userRef = this.db.collection(FirestoreKey.users).doc(uid)

        await userRef.create(info)
    }

    async updateAccountData(uid: string, fields: Partial<UserSchema>): Promise<void> {
        const userRef = this.db.collection(FirestoreKey.users).doc(uid)
        await userRef.update(fireEncode(fields))
    }

    getAccountData(uid: string): Promise<User> {
        const userRef = this.db.collection(FirestoreKey.users).doc(uid)
        return userRef.get().then(doc => {
            if (doc.exists) {
                return fireDecode(User, doc)
            } else {
                throw new HttpsError('not-found', `User id: ${uid} not found.`)
            }
        })
    }

    async deleteAccountData(uid: string): Promise<void> {
        const userRef = this.db.collection(FirestoreKey.users).doc(uid)
        await userRef.delete()
    }


    async updateUserAccount(uid: string, info: UserSchema | Partial<UserSchema>): Promise<void> {
        const roles: Partial<Record<Role, boolean>> = {}

        if (info.driverInfo) {
            roles['Driver'] = true
        }
        if (info.riderInfo) {
            roles['Rider'] = true
        }

        const userRef = this.db.collection(FirestoreKey.users).doc(uid)

        await userRef.update(info)
    }

    async storeUserDeviceToken(uid: string, tokenIDs: tokenSchema): Promise<void> {

        await this.db.collection(FirestoreKey.FCMTokens).doc(uid).create(fireEncode(tokenIDs))
    }

    async updateDeviceTokenList(uid: string, data: tokenSchema): Promise<void> {

        const doc = this.db.collection(FirestoreKey.FCMTokens).doc(uid)
        await doc.update(data)
    }

    async createEarning(driverID: string, data: earnings) {
        const userEarnings = this.db.collection(FirestoreKey.users).doc(driverID).collection(FirestoreKey.earnings).doc()

        await userEarnings.create(data)
    }

    async getAllEarnings(uid: string): Promise<earnings[]> {

        // return this.db.collection(FirestoreKey.users).doc(uid).collection(FirestoreKey.earnings).get().then(snap => {
        //     return snap.docs.map(doc => doc.data()) as CreditCardSchema[]
        // })
        return this.db.collection(FirestoreKey.users).doc(uid).collection(FirestoreKey.earnings).get().then(snap => {
            return snap.docs.map(doc => doc.data()) as earnings[]
        })
        // const documents = await this.db.collection(FirestoreKey.users).doc(uid).collection(FirestoreKey.earnings).get()
        // .then((snapshot) => {
        //     snapshot.docs.map(doc => console.log(doc.data()))
        // })


    }

    async getEarningsByMonth(uid: string, start: string, end: string): Promise<number> {
        const startMonth = new Date(start)
        const endMonth = new Date(end)
        var monthlyEarnings: number = 0
        const documents = await this.db.collection(FirestoreKey.users).doc(uid).collection(FirestoreKey.earnings).where('date', '>=', startMonth).where('date', '<=', endMonth).get()
            .then((snapshot) => {
                snapshot.docs.map(doc => monthlyEarnings += doc.data().amount)
            })
        console.log(documents)
        console.log(monthlyEarnings)
        return monthlyEarnings
    }


    //TODO: Move this to a tripsDAO class and change this to get trips and use the service class for earnings.
    // async getTrips(riderID: string, startDate: Date, endDate: Date): Promise<number> {

    // const trips = await this.db.collection('trips')
    //     .where('driverID', '==', driverID)
    //     .where('date', '>', startDate)
    //     .where('date', '<', endDate)
    //     .get()
    //     .then(snapshot => {
    //         return snapshot.docs.map(doc => {
    //             return doc.data() as Trip
    //         })
    //     }).then(trips => {
    //         let sum: number = 0
    //         trips.forEach(trip => {
    //             sum += trip.totalFairs
    //         })
    //         return sum
    //     })

    // this.db.collection('trips')
    //     .where(riderID, '==', true)



    // }


}
