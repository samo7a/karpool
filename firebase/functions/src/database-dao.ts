import * as admin from 'firebase-admin'
import { User, UserUpdateFields } from './models/user'
import { FirestoreDecoder } from './utils/firestore-decoder'
import { FirestoreEncoder } from './utils/firestore-encoder'

/**
 * Since other functionality may depend on this, we'll use an interface so we can make a mock later
 * for unit testing.
*/
export interface DatabaseDAOInterface {

    /**
     * Creates a user document to hold the user's account information.
     * Throws an error if a user document already exists under the given userID.
     * @param userID The user's id.
     * @param user A user class instance.
     */
    createUserInfo(userID: string, user: User): Promise<void>

    /**
     * Updates only the fields provided in the fields parameter. All other fields will be left unmodified.
     * @param userID The user's id.
     * @param fields Fields to update in the user document.
     */
    updateUserInfo(userID: string, fields: UserUpdateFields): Promise<void>

    /**
     * Gets a user's data as a User class instance given a userID.
     * @param userID The user's id.
     */
    getuserInfo(userID: string): Promise<User>

    /**
     * Deletes a user's document.
     * This method should only be called when a user has "deleted" both their driver and rider information.
     * @param userID The user's id.
     */
    deleteUserInfo(userID: string): Promise<void>

    /**
     * Deletes all rider information associated with a user account. 
     * This method should only be called when a user is "deleting" their rider account.
     * @param userID The user's id.
     */
    deleteRiderInfo(userID: string): Promise<void>

    /**
     * Deletes all driver information associated with a user's account.
     * This method should only be called when a user is "deleting" their driver account.
     * @param userID The user's id.
     */
    deleteDriverInfo(userID: string): Promise<void>

}

export const FirestoreKey = {

    users: 'users'
}

interface Trip {
    date: Date
    totalFairs: number
}

/**
 * A DAO for communicating with the database. The purpose of this class is to decouple the database 
 * implementation from the other business logic code.
 * https://softwareengineering.stackexchange.com/a/220917
 */
export class DatabaseDAO implements DatabaseDAOInterface {

    db: admin.firestore.Firestore

    constructor(db: admin.firestore.Firestore) {
        this.db = db
    }

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

    async createUserInfo(userID: string, user: User): Promise<void> {
        const userRef = this.db.collection(FirestoreKey.users).doc(userID)
        const data = new FirestoreEncoder().encode(user)
        await userRef.create(data)
    }

    async updateUserInfo(userID: string, fields: UserUpdateFields): Promise<void> {
        const userRef = this.db.collection(FirestoreKey.users).doc(userID)
        const data = new FirestoreEncoder().encode(fields)
        await userRef.update(data)
    }

    getuserInfo(userID: string): Promise<User> {
        const userRef = this.db.collection(FirestoreKey.users).doc(userID)
        return userRef.get().then(doc => {
            return new FirestoreDecoder().decodeDoc(User, doc)
        })
    }

    async deleteUserInfo(userID: string): Promise<void> {
        const userRef = this.db.collection(FirestoreKey.users).doc(userID)
        await userRef.delete()
    }

    deleteRiderInfo(userID: string): Promise<void> {
        /**
         * Set isRider flag to false
         * Delete rider reviews
         * 
         */
        throw new Error('Unimplemented.')
    }

    deleteDriverInfo(userID: string): Promise<void> {
        /**
        * delete drivers licenseNum
        * delete vehicle ID
        * delete vehicle
        * set isDriver flag to false
        * delete banking information
        * Delete driver reviews
        */
        throw new Error('Unimplemented')
    }


}