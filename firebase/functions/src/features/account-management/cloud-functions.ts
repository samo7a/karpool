

import * as functions from 'firebase-functions'
import { newAccountService, newVehicleDAO } from '../../index'
import { validateRegistrationData } from './validation'
import { validateBool, validateDateOptional, validateString, validateStringOptional } from '../../utils/validation'
import { validateAuthorization } from '../../data-access/auth/utils'
import { HttpsError } from 'firebase-functions/lib/providers/https'
import { VehicleSchema } from '../../data-access/vehicle/types'



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



/**
 * https://stackoverflow.com/a/47914631/6738247
 * Allows optional values for nested properties.
 */
export type RecursivePartial<T> = {
    [P in keyof T]?: RecursivePartial<T[P]>;
};

function validateVehicleUpdateData(data: any): RecursivePartial<VehicleSchema> {
    return {
        color: validateStringOptional(data.color),
        insurance: {
            provider: validateStringOptional(data.provider),
            coverageType: validateStringOptional(data.coverageType),
            startDate: validateDateOptional(data.startDate),
            endDate: validateDateOptional(data.endDate)
        },
        licensePlateNum: validateStringOptional(data.licensePlateNum),
        make: validateStringOptional(data.make),
        year: validateStringOptional(data.year)
    }
}




