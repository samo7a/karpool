import { Address } from "./address"

export interface UserUpdateFields {
    firstName?: string
    lastName?: string
    phone?: string
    email?: string
    gender?: string
    dob?: Date
    address?: Address
    joinDate?: Date
    driverInfo?: DriverInfo
    riderInfo?: RiderInfo
}

/**
 * Information associated with a user who is a driver.
 */
export interface DriverInfo {

    /**
     * A flag to determine if a user has registered as a driver. (used for queries)
     */
    isDriver: boolean

    /**
     * The user's driver's license number.
     */
    licenseNum: string

    /**
     * The average rating of the driver based on reviews of riders. (0-5)
     */
    rating: number

    /**
     * Number of ratings the driver has received from riders. 
     * Used to calculate the new average rating.
     */
    ratingCount: number

}

/**
 * Information associated with a user who is a rider.
 */
export interface RiderInfo {

    /**
     * A flag to determine if a user has registered as a driver. (used for queries)
     */
    isRider: boolean

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

export class User {

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
    gender: string

    /**
     * The user's date of birth.
     */
    dob: Date

    /**
     * The user's current address of residency.
     */
    address: Address

    /**
     * The date the user joined the Karpool platform.
     */
    joinDate: Date

    /**
     * The information associated with a user who is a driver.
     * Is only present if the user has registered as a driver.
     */
    driverInfo?: DriverInfo

    /**
     * The information associated with a user who is a rider.
     * Is only present if the user has registered as a rider.
     */
    riderInfo?: RiderInfo

    /**
     * The url pointing to the location of the image associated with the user's profile.
     */
    profileURL?: string


    constructor(
        firstName: string,
        lastName: string,
        phone: string,
        email: string,
        gender: string,
        dob: Date,
        address: Address,
        joinDate: Date,
        driverInfo?: DriverInfo,
        riderInfo?: RiderInfo,
        profileURL?: string
    ) {
        this.firstName = firstName
        this.lastName = lastName
        this.phone = phone
        this.email = email
        this.gender = gender
        this.dob = dob
        this.address = address
        this.joinDate = joinDate
        this.driverInfo = driverInfo
        this.riderInfo = riderInfo
        this.profileURL = profileURL
    }
}


/**
 * Fields public available to all users on Karpool platform.
 */
export interface UserFieldsPublic {

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
     * The user's gender.
     */
    gender: string

    /**
     * The date the user joined the Karpool platform.
     */
    joinDate: Date

    /**
     * The user's driver rating. (0-5)
     */
    driverRating?: number

    /**
     * The user's rider rating. (0-5)
     */
    riderRating?: number

    /**
     * The url pointing to the location of the image associated with the user's profile.
     */
    profileURL?: string

}