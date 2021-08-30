import { Address } from "./address";


export interface RiderRegistrationInfo {

    /**
     * The user's firstName.
     */
    firstName: string

    /**
     * The user's lastName.
     */
    lastName: string

    /**
     * The user's gender.
     */
    gender: string

    /**
     * The user's email address.
     */
    email: string

    /**
     * The user's account password.
     */
    password: string

    /**
     * The user's date of birth.
     */
    dob: Date

    /**
     * The user's current address of residency.
     */
    address: Address

    /**
     * The user's phone number.
     */
    phone: string

    /**
     * The date the user registered on the platform.
     */
    joinDate: Date

}

export interface DriverRegistrationInfo {

    /**
     * The user's firstName.
     */
    firstName: string

    /**
     * The user's lastName.
     */
    lastName: string

    /**
     * The user's gender.
     */
    gender: string

    /**
     * The user's email address.
     */
    email: string

    /**
     * The user's account password.
     */
    password: string

    /**
     * The user's date of birth.
     */
    dob: Date

    /**
     * The user's current address of residency.
     */
    address: Address

    /**
     * The user's phone number.
     */
    phone: string

    /**
     * The date the user registered on the platform.
     */
    joinDate: Date

    /**
     * The user's driver's license number.
     */
    licenseNum: string


}