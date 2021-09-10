

import * as functions from 'firebase-functions'
import { newAccountService } from '../../index'
import { validateRegistrationData } from './validation'
import { validateBool, validateString } from '../../utils/validation'
import { validateAuthorization } from '../../auth/utils'
import { HttpsError } from 'firebase-functions/lib/providers/https'
import { driverRegisterDummy } from '../../dummy-data'




/**
 * Registers a new user account.
 */
export const registerUser = functions.https.onCall(async (data, context) => {

    const registrationData = validateRegistrationData(driverRegisterDummy())

    return newAccountService().registerUser(registrationData).catch(err => {
        throw new HttpsError('internal', err.message)
    })

})


/**
 * Adds a role to the user's account after they have register
 * Params: 
 * {
 *  driverInfo: DriverInfoRoleData
 *  role: string ('Driver' | 'Rider')
 * }
 */
export const addRole = functions.https.onCall(async (data, context) => {

    const uid = validateAuthorization(context)

    return newAccountService().addRole(uid, data.driverInfo, data.role)

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

    const driver = validateBool(data.driver)

    const includePrivateFields = callerUID === targetUID

    return newAccountService().getUserProfile(targetUID, driver, includePrivateFields)
        .then(fields => {
            return JSON.parse(JSON.stringify(fields))
        })

})