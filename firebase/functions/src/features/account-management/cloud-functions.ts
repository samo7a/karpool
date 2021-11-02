

import * as functions from 'firebase-functions'
import { newAccountService, newVehicleDAO } from '../../index'
import { validateRegistrationData } from './validation'
import { validateBool, validateDate, validateString } from '../../utils/validation'
import { validateAuthorization } from '../../data-access/auth/utils'
import { HttpsError } from 'firebase-functions/lib/providers/https'
import { VehicleSchema } from '../../data-access/vehicle/types'




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
    return newAccountService().editUserProfile(data.uid, data.phoneNum, data.email, data.pic)
})

export const getEarnings = functions.https.onCall(async (data,context) => {
    return newAccountService().getEarnings(data.uid)
})


export const updateDriverInfo = functions.https.onCall(async (data,context) => {
    const callerUID = validateAuthorization(context)
    
    const formatedData = validateDriverInfo(data)
    return newVehicleDAO().updateVehicle(callerUID,formatedData)
})

function validateDriverInfo(data: any): Partial<VehicleSchema>{
    return {
        color: validateString(data.color) ,
        insurance: {
            provider: validateString(data.insurance.provider),
            coverageType: validateString(data.insurance.coverageType),
            startDate: validateDate(data.insurance.startDate) ,
            endDate: validateDate(data.insurance.endDate)
        },
        licensePlateNum: validateString(data.licensePlate),
        make: validateString(data.make),
        year: validateString(data.year)
    }
}

