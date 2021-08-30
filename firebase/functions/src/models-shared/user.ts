import { DriverInfoSchema, RiderInfoSchema, UserSchema } from "../database/user/schema"
import { Address } from "./address"

/**
 * Internal data model that represents a User in the system.
 */
export class User implements UserSchema {

    firstName: string
    lastName: string
    phone: string
    email: string
    gender: string
    dob: Date
    address: Address
    joinDate: Date
    driverInfo?: DriverInfoSchema
    riderInfo?: RiderInfoSchema
    profileURL?: string
    roles: Partial<Record<string, boolean>>

    constructor(
        firstName: string,
        lastName: string,
        phone: string,
        email: string,
        gender: string,
        dob: Date,
        address: Address,
        joinDate: Date,
        roles: Partial<Record<string, boolean>>,
        driverInfo?: DriverInfoSchema,
        riderInfo?: RiderInfoSchema,
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
        this.roles = roles
        this.driverInfo = driverInfo
        this.riderInfo = riderInfo
        this.profileURL = profileURL
    }

}






/**
 * Publicly facing user data used for get and delete methods.
 * The purpose of this interface is to transform the user object so we can choose which fields that are public and private.
 */
export interface UserFieldsExternal {

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
     * The number of ratings a user has as a driver.
     */
    driverRatingCount?: number

    /**
     * The user's rider rating. (0-5)
     */
    riderRating?: number

    /**
     * The number of ratings a user has a rider.
     */
    riderRatingCount?: number

    /**
     * The url pointing to the location of the image associated with the user's profile.
     */
    profileURL?: string


    //MARK: Private fields


    /**
     * The user's license number if they are a driver.
     * Only available to the user who owns the account to this user.
     */
    licenseNum?: string



}


