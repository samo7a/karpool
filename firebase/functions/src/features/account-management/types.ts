

export interface UserRegistrationData {

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
    dob: string //  yyyy-mm-dd

    /**
     * The user's phone number.
     */
    phone: string


    /**
     * 
     */
    cardNum?: number

    cardExpDate?: string

    cardCVC?: number


    stripeToken?: string


    /**
     * Base 64
     */
    profilePicData: string

    /**
     * 
     */
    accountNum?: string

    /**
     * 
     */
    routingNum?: string

    /**
     * 
    */
    licenseNum?: string

    /**
     * 
     */
    licenseExpDate?: string

    /**
     * 
     */
    make?: string

    /**
     * 
     */
    color?: string


    /**
     * 
     */
    isDriver: boolean

    year?: string

    plateNum?: string

    provider?: string

    coverage?: string

    startDate?: Date

    endDate?: Date

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


    /**
     * A dictionary containing the role as a string key and the value as true. 
     * Current possible keys are "Rider" or "Driver".
     * The values will only be true. If the role isn't in the dictionary then the user implicitly doesn't have a role.
     */
    roles: Record<string, boolean>


    //TODO: Bank info


}





