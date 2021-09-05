

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
    roles: Partial<Record<string, boolean>>

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
    profileURL?: string

    bankAccount?: {
        accountNum: string
        routingNum: string
    }
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

    /**
     * 
     */
    stripeToken: string
}




export interface CreditCardSchema {

    cardNum: number

    cvc: number

    /**
     * Expiration date in form of MM/YY
     */
    expDate: string

    uid: string


}