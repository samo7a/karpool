//MARK: Parameter Shapes


/**
 * UID 
 */

export interface UserRegistrationData {

    /**
     * The user's firstName. (Driver&Rider)
     */
    firstName: string

    /**
     * The user's lastName. (Driver&Rider)
     */
    lastName: string

    /**
     * The user's gender. (Driver&Rider)
     */
    gender: string

    /**
     * The user's email address. (Driver&Rider)
     */
    email: string

    /**
     * The id associated with the created user account.
     */
    uid: string

    /**
     * The user's date of birth. (Driver&Rider)
     */
    dob: string //  yyyy-mm-dd 

    /**
     * The user's phone number. (Driver&Rider)
     */
    phone: string

    /**
     * Base 64 encoded (Driver&Rider)
     */
    profilePicData: string

    /**
     * Bank account number (Driver)
     */
    accountNum?: string

    /**
     * Bank account routing number (Driver)
     */
    routingNum?: string

    /**
     * Driver's license number. (Driver)
     */
    licenseNum?: string

    /**
     * Driver's license expiration date (yyyy-mm-dd).
     * (Driver)
     */
    licenseExpDate?: string

    /**
     * The car's make.
     * (Driver)
     */
    make?: string

    /**
     * The vehicle's color.
     * (Driver)
     */
    color?: string


    /**
     * Flag for determining if the user is registering as a rider or driver.
     * (Driver = true; Rider = false)
     */
    isDriver: boolean

    /**
     * The vehicle's year.
     * (Driver)
     */
    year?: string

    /**
     * The vehicle's license plate number.
     * (Driver)
     */
    plateNum?: string

    /**
     * The vehicle's insurance provider.
     * (Driver)
     */
    provider?: string

    /**
     * The vehicle's insurance coverage.
     * (Driver)
     */
    coverage?: string

    /**
     * The insurance coverage start date as (yyyy-mm-dd)
     * (Driver)
     */
    startDate?: string

    /**
     * The insurance coverage end date as (yyyy-mm-dd)
     * (Driver)
     */
    endDate?: string

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

    email?: string

    /**
     * The user's phone number.
     */
    phone: string

    /**
     * The user's gender.
     */
    gender?: string

    /**
     * The date the user joined the Karpool platform.
     */
    joinDate?: Date

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


    /**
     * A dictionary containing the role as a string key and the value as true. 
     * Current possible keys are "Rider" or "Driver".
     * The values will only be true. If the role isn't in the dictionary then the user implicitly doesn't have a role.
     */
    roles?: Record<string, boolean>


    //TODO: Bank info


}





