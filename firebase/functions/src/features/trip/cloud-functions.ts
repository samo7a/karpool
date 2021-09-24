
import * as functions from "firebase-functions"
import { HttpsError } from "firebase-functions/lib/providers/https"
import { validateAuthorization } from "../../auth/utils"
import { newTripService } from '../../index'
import { validateAddTripData } from "./validation"


export const searchTrips = functions.https.onCall((data, context) => {

    // const uid = validateAuthorization(context)

    //start end points
})

/**
 * 
 */
export const createAddedTrip = functions.https.onCall(async (data, context) => {

    const uid = validateAuthorization(context)

    const addTripData = validateAddTripData(data)

    return newTripService().createAddedTrip(uid, addTripData)

})


/**
 * 
 */
export const getDriverTrips = functions.https.onCall(async (data, context) => {
    //validate who is calling function ???
    const uid = validateAuthorization(context)

    if (uid === data.driverID) {
        return newTripService().getDriverTrips(data.driverID)
    } else {
        throw new HttpsError('failed-precondition', 'Invalid user')
    }
})


/**
 * 
 */
export const getRiderTrips = functions.https.onCall(async (data, context) => {

    const uid = validateAuthorization(context)
    console.log(data.riderID, uid)
    if (uid === data.riderID) {
        return newTripService().getRiderTrips(data.riderID)
    } else {
        throw new HttpsError('failed-precondition', 'Invalid user')
    }
})

/**
 * 
 */
export const cancelRidebyRider = functions.https.onCall(async (data, context) => {

    const uid = validateAuthorization(context)

    if (uid === data.riderID) {
        return newTripService().cancelRide(data.riderID, data.tripID)
    } else {
        throw new HttpsError('failed-precondition', 'Invalid user')
    }
})


export const acceptRiderRequest = functions.https.onCall(async (data, context) => {
    const uid = validateAuthorization(context)

    if (uid) {


        return newTripService().acceptRiderRequest(data.riderID, data.tripID)
    }
    else {
        throw new HttpsError('failed-precondition', 'Invalid User')
    }
})


export const getDriverCompletedTrips = functions.https.onCall(async (data, context) => {
    const uid = validateAuthorization(context)
    if (uid) {
        return newTripService().getDriverCompletedTrips(data.driverID)
    }
    else {
        throw new HttpsError('failed-precondition', 'Invalid User')
    }
})



export const getRiderCompletedTrips = functions.https.onCall(async (data, context) => {
    const uid = validateAuthorization(context)
    if (uid) {
        return newTripService().getRiderCompletedTrips(data.riderID)
    }
    else {
        throw new HttpsError('failed-precondition', 'Invalid User')
    }


})
