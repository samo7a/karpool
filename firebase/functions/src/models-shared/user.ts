import { DriverInfoSchema, RiderInfoSchema, UserSchema } from "../data-access/user/schema"

/**
 * Internal data model that represents a User in the system.
 */
export class User implements UserSchema {

    firstName: string
    lastName: string
    phone: string
    email: string
    gender: string
    dob: string
    joinDate: Date
    driverInfo?: DriverInfoSchema
    riderInfo?: RiderInfoSchema
    profileURL?: string
    roles: Record<string, boolean>

    bankAccount?: {
        accountNum: string
        routingNum: string
    }

    constructor(
        firstName: string,
        lastName: string,
        phone: string,
        email: string,
        gender: string,
        dob: string,
        joinDate: Date,
        roles: Record<string, boolean>,
        driverInfo?: DriverInfoSchema,
        riderInfo?: RiderInfoSchema,
        profileURL?: string,
        bankAccount?: {
            accountNum: string,
            routingNum: string
        }
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
        this.bankAccount = bankAccount
    }

    getFullName(): string {
        return `${this.firstName} ${this.lastName}`
    }

}



