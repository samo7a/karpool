import * as admin from 'firebase-admin'

/**
 * Since other functionality may depend on this, we'll use an interface so we can make a mock later
 * for unit testing.
*/
export interface DatabaseDAOInterface {

    /**
     * Creates a document, in the rider collection, containing the rider's information.
     * @param firstName The rider's firstName.
     * @param lastName The rider's lastName.
     * @param gender The rider's gender.
     * @param email The rider's email address.
     * @param dob The rider's date of birth.
     * @param address The rider's street address.
     * @param phone The rider's phone number.
     * @param joinDate The date the rider joined the platform.
     * @returns The created rider's document id.
     */
    createRider(
        firstName: string,
        lastName: string,
        gender: string,
        email: string,
        dob: Date,
        address: string,
        phone: string,
        joinDate: Date
    ): Promise<string>

    /**
     * Deletes the rider's document data.
     * @param riderID The rider's document id.
     */
    deleteRider(riderID: string): Promise<void>

    /**
     * Creates a document, in the drivers collection, containing the driver's information.
     * @param firstName The driver's firstName.
     * @param lastName The driver's lastName.
     * @param gender The driver's gender.
     * @param email The driver's email.
     * @param dob The driver's date of birth.
     * @param address The driver's street address.
     * @param phone The driver's phone number.
     * @param joinDate The date the driver joined the platform.
     * @param driversLicense The driver's license.
     * @returns The driver's document id.
     */
    createDriver(
        firstName: string,
        lastName: string,
        gender: string,
        email: string,
        dob: Date,
        address: string,
        phone: string,
        joinDate: Date,
        driversLicense: string
    ): Promise<string>

    /**
     * Deletes the driver's document data.
     * @param driverID The driver's document id.
     */
    deleteDriver(driverID: string): Promise<void>

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

    createRider(
        firstName: string,
        lastName: string,
        gender: string,
        email: string,
        dob: Date,
        address: string,
        phone: string,
        joinDate: Date
    ): Promise<string> {
        throw new Error('Unimplemented.')
    }

    deleteRider(riderID: string): Promise<void> {
        throw new Error('Unimplemented.')
    }

    createDriver(
        firstName: string,
        lastName: string,
        gender: string,
        email: string,
        dob: Date,
        address: string,
        phone: string,
        joinDate: Date,
        driversLicense: string
    ): Promise<string> {
        throw new Error('Unimplemented.')
    }

    deleteDriver(driverID: string): Promise<void> {
        throw new Error('Unimplemented.')
    }


}