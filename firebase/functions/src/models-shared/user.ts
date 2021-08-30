import { DriverInfoSchema, RiderInfoSchema, UserSchema } from "../database/user/schema"

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
        this.joinDate = joinDate
        this.roles = roles
        this.driverInfo = driverInfo
        this.riderInfo = riderInfo
        this.profileURL = profileURL
    }

}



