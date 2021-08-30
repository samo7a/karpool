
//This file is for organizing complex types used by the DAO.

//Reason for this is to decouple the DAO methods parameters / return types from database schema.
//This way we only have to fix the code in one place if we change the database schema (The DAO).
export interface UserCreationInfo {

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
    dob: Date

    driverInfo?: {
        licenseNum: string
        rating: number
        ratingCount: number
    }

    riderInfo?: {
        rating: number
        ratingCount: number
    }

}


export type Role = 'Rider' | 'Driver'