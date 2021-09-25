
import * as functions from "firebase-functions"
import { HttpsError } from "firebase-functions/lib/providers/https"
import { validateAuthorization } from "../../auth/utils"
import { newTripService } from '../../index'
import { validateDate, validateNumber, validateStringArray } from "../../utils/validation"
import { validateAddTripData } from "./validation"


export const getCoordinates = functions.https.onCall((data, context) => {

    const coordinates = validateStringArray(data)

    console.log(coordinates)

})

export const searchTrips = functions.https.onCall(async (data, context) => {

    await validateAuthorization(context)

    const info = {
        pickupLocation: {
            x: validateNumber(data.pickupLocation.x),
            y: validateNumber(data.pickupLocation.y)
        },
        dropoffLocation: {
            x: validateNumber(data.dropoffLocation.x),
            y: validateNumber(data.dropoffLocation.y)
        },
        passengerCount: validateNumber(data.passengerCount),
        startDate: validateDate(data.startDate)
    }

    //Cut off at the end of the day.
    const endDate = new Date(info.startDate.getTime())
    endDate.setUTCHours(23, 59, 59)

    return newTripService().searchTrips(info.pickupLocation, info.dropoffLocation, info.startDate, endDate, info.passengerCount)

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

    const uid = "P6XgCtvUksX42QoH484Oy27SV6O2"//validateAuthorization(context)

    if (uid === data.riderID) {
        return newTripService().cancelRidebyRider(data.riderID, data.tripID)
    } else {
        throw new HttpsError('failed-precondition', 'Invalid user')
    }
})

export const cancelRidebyDriver = functions.https.onCall(async (data, context) => {

    const uid = validateAuthorization(context)

    if (uid === data.DriverID) {
        return newTripService().cancelRidebyDriver(data.driverID, data.riderID, data.tripID)
    } else {
        throw new HttpsError('failed-precondition', 'Invalid user')
    }
})

export const declineRideRequest = functions.https.onCall(async (data, context) => {

    const uid = validateAuthorization(context)

    if (uid === data.DriverID) {
        return newTripService().declineRideRequest(data.driverID, data.riderID, data.tripID)
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
