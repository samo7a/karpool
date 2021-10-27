import { firestore } from "firebase-admin";
import { Role } from "./types";

/**
 * Exact schema of the user record in the database.
 * Do not use this outside of its DAO since it is subject to change.
 */
export interface UserSchema {

    /**
    * The user's first name.
    */
    firstName: string

    /**
     * The user's last name.
     */
    lastName: string

    /**
     * The user's phone number.
     */
    phone: string

    /**
     * The user's email address.
     */
    email: string

    /**
     * The user's gender.
     */
    gender?: string

    /**
     * The user's date of birth.
     */
    dob: string //yyyy-mm-dd

    /**
     * The date the user joined the Karpool platform.
     */
    joinDate: Date

    /**
     * A map to allow query of users by role. (Rider or Driver)
     */
    roles: Partial<Record<Role, boolean>>

    /**
     * Information specific to a user who is a driver.
     * Only present if the user has registered as a driver.
     */
    driverInfo?: DriverInfoSchema

    /**
     * Information specific to a user who is a rider.
     * Only present if the user has registered as a rider.
     */
    riderInfo?: RiderInfoSchema

    /**
     * The url pointing to the location of the image associated with the user's profile.
     */
    profileURL: string

    /**
     * Path of the profile url so the file can be deleted later if needed.
     */
    profilePicStoragePath: string

    stripeCustomerID: string

}


export interface DriverInfoSchema {

    /**
     * The user's driver's license number.
     */
    licenseNum: string

    /**
     * 
     */
    licenseExpDate: string

    /**
     * The average rating of the driver based on reviews of riders. (0-5)
     */
    rating: number

    /**
     * Number of ratings the driver has received from riders. 
     * Used to calculate the new average rating.
     */
    ratingCount: number

    /**
     * Driver's Bank Account number. 
     */
    accountNum: string

    /**
    * Driver's Bank routing number. 
    */
    routingNum: string

    /**
     * drvier account balance for weekly payment
     */
    accountBalance: number

}


export interface RiderInfoSchema {

    /**
     * The average rating of the rider based on reviews of drivers. (0-5)
     */
    rating: number

    /**
     * Number of ratings the rider has received from drivers. 
     * Used to calculate the new average rating.
     */
    ratingCount: number
}


export interface tokenSchema {

    tokenIDs: string[]

}

export interface earnings {
    amount: number

    tripID: string

    date: firestore.Timestamp

    dayOfWeek: string

}


export interface week {
    weekNum: number

    amount: number
}

export interface month {
    month: number

    amount: number
}

