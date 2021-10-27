

import * as functions from 'firebase-functions'
import { newAccountService, newVehicleDAO } from '../../index'
import { validateRegistrationData, validateVehicleUpdateData } from './validation'
import { validateBool, validateString } from '../../utils/validation'
import { validateAuthorization } from '../../data-access/auth/utils'
import { HttpsError } from 'firebase-functions/lib/providers/https'



export const deleteAccount = functions.https.onCall(async (data, context) => {

    const callerUID = validateAuthorization(context)

    await newAccountService().deleteAccount(callerUID).catch(err => {
        throw new HttpsError('internal', `Cannot delete user account. Reason: ${err.message}`)
    })

})


/**
 * Registers a new user account.
 */
export const registerUser = functions.https.onCall(async (data, context) => {

    const registrationData = validateRegistrationData(data)

    return newAccountService().registerUser(registrationData).catch(err => {
        throw new HttpsError('internal', err.message)
    })

})

export const storeDeviceToken = functions.https.onCall(async (data, context) => {

    const uid = validateAuthorization(context)
    // const registrationData = validateString(data)

    return newAccountService().storeDeviceToken(uid, data).catch(err => {
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


export const setBankAccount = functions.https.onCall(async (data, context) => {

    const callerUID = validateAuthorization(context)

    const accountNum: string = validateString(data.accountNum)
    const routingNum: string = validateString(data.routingNum)

    return newAccountService().setBankAccount(callerUID, routingNum, accountNum)

})


export const addCreditCard = functions.https.onCall(async (data, context) => {

    const uid = validateAuthorization(context)

    const cardToken = validateString(data.cardToken)

    return newAccountService().addCreditCard(uid, cardToken)
})

export const getCreditCards = functions.https.onCall(async (data, context) => {

    const uid = validateAuthorization(context)

    return newAccountService().getCreditCards(uid)
})

export const deleteCreditCard = functions.https.onCall(async (data, context) => {

    const uid = validateAuthorization(context)

    const cardID = validateString(data.cardID)

    return newAccountService().deleteCreditCard(uid, cardID)

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

export const editUserProfile = functions.https.onCall(async (data, context) => {

    const callerUID = validateAuthorization(context)

    return newAccountService().editUserProfile(callerUID, data.phoneNum, data.email, data.pic)

})

export const getEarnings = functions.https.onCall(async (data, context) => {

    const callerUID = validateAuthorization(context)

    return newAccountService().getEarnings(callerUID)

})


export const updateVehicle = functions.https.onCall(async (data, context) => {

    const callerUID = validateAuthorization(context)

    //Only the authenticated caller can update their vehicle.
    return newVehicleDAO().updateVehicle(callerUID, validateVehicleUpdateData(data))
})


export const getVehicle = functions.https.onCall(async (data, context) => {

    const callerUID = validateAuthorization(context)

    //Only the authenticated caller can get their vehicle.
    return newVehicleDAO().getVehicle(callerUID)
})




