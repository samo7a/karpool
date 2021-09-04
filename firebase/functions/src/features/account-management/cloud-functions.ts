

import * as functions from 'firebase-functions'
import { validateAuthorization } from '../../auth/utils'
import { newAccountService } from '../../index'
import { validateString } from '../../utils/validation'
import { validateRegistrationData } from './validation'



/**
 * Registers a new user account.
 */
export const registerUser = functions.https.onCall(async (data, context) => {

    const registrationData = validateRegistrationData(data)

    return newAccountService().registerUser(registrationData)

    /**
     * TODO:
     * Validate data (DONE)
     * Verify account doesn't already exist. (DONE)
     * Create the account in auth (DONE)
     * Store the profile picture 
     * Get URL from picture 
     * Cretae the user account document. (DONE)
     */


})

/**
 * Function Name: account-registerUser
 * Parameters:
 * 
 */

/**
 * Function Name: account-getUser
 * 
 * Parameters: 
 * uid: string
 * driver: boolean
 * 
 * Returns:
 * 
 * 
 */

//  firstName: string
//  lastName: string
//  phone: string
//  gender: string
//  joinDate: Date
//  driverRating?: number
//  driverRatingCount?: number
//  riderRating?: number
//  riderRatingCount?: number
//  profileURL?: string
// licenseNum ?: string
// roles: Record < string, boolean >

/**
 * 
 */
export const getUser = functions.https.onCall(async (data, context) => {

    const callerUID = validateAuthorization(context)

    const targetUID = validateString(data.uid)
    // const isDriver = validateBool(data.driver)

    // user trip rider 

    const includePrivateFields = callerUID === targetUID

    return newAccountService().getRiderProfile(targetUID, includePrivateFields)
        .then(fields => {
            return JSON.stringify(fields)
        })

})