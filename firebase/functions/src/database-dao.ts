import * as admin from 'firebase-admin'
import { HttpsError } from 'firebase-functions/lib/providers/https'
import { User } from './models/user'
import { FirestoreEncoder } from './utils/firestore-encoder'

/**
 * Since other functionality may depend on this, we'll use an interface so we can make a mock later
 * for unit testing.
*/
export interface DatabaseDAOInterface {

    /**
     * Creates a user document to hold the user's account information.
     * Throws an error if a user document already exists under the given userID.
     * @param userID The user's id
     * @param user A user class instance.
     */
    createUserInfo(userID: string, user: User): Promise<void>

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

    async createUserInfo(userID: string, user: User): Promise<void> {
        const userRef = this.db.collection(FirestoreKey.users).doc(userID)
        await this.db.runTransaction(transaction => {
            return transaction.get(userRef).then(doc => {
                if (doc.exists) {
                    throw new HttpsError('already-exists', `Cannot create user document under id: ${userID} because one already exists.`)
                } else {
                    const data = new FirestoreEncoder().encode(user)
                    userRef.set(data)
                }
            })
        })
    }

    async deleteUserInfo(userID: string): Promise<void> {
        await this.db.collection(FirestoreKey.users).doc(userID).delete()
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