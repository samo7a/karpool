

import * as admin from 'firebase-admin'
import { FirestoreKey } from '../../constants'
import { UserSchema } from './schema'
import { Role } from './types'
import { User } from '../../models-shared/user'
import { fireDecode } from '../utils/decode'
import { fireEncode } from '../utils/encode'
import { CreditCardSchema } from '../payment-dao/schema'
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
        return userRef.get().then(doc => fireDecode(User, doc))
    }

    async deleteAccountData(uid: string): Promise<void> {
        const userRef = this.db.collection(FirestoreKey.users).doc(uid)
        await userRef.delete()
    }


    //MARK: Credit Card Methods
    async createCreditCard(data: CreditCardSchema): Promise<void> {
        const ref = this.db.collection(FirestoreKey.creditCards).doc()
        await ref.create(fireEncode(data))
    }

    async updateUserAccount(uid: string, info: UserSchema): Promise<void> {
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
