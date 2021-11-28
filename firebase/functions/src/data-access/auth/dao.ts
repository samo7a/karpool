
import * as admin from 'firebase-admin'


export interface AuthenticationDAOInterface {

    /**
     * Creates a new user account in Firebase authentication.
     * @param email The user account email address.
     * @param password The user account password.
     */
    // registerAccount(email: string, password: string): Promise<string>

    /**
     * Gets the userID given an email address associated with the user account.
     * @param email The user account email.
     */
    getUserID(email: string): Promise<string>


    /**
     * 
     * @param uid The id associated with the 
     */
    deleteAccount(uid: string): Promise<void>

}

export class AuthenticationDAO implements AuthenticationDAOInterface {

    private auth: admin.auth.Auth

    constructor(auth: admin.auth.Auth) {
        this.auth = auth
    }

    // registerAccount(email: string, password: string): Promise<string> {
    //     return this.auth.createUser({
    //         email: email,
    //         password: password
    //     }).then(async record => {
    // await this.auth.generateEmailVerificationLink(email).then((link) => {
    //     console.log('LINKE', link)
    // }).catch(err => {
    //     console.log('ERR', err.message)
    // })
    //         return record.uid
    //     })
    // }

    getUserID(email: string): Promise<string> {
        return this.auth.getUserByEmail(email).then(record => {
            return record.uid
        })
    }

    deleteAccount(uid: string): Promise<void> {
        return this.auth.deleteUser(uid)
    }
}