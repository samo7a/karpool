
import * as functions from "firebase-functions"
import { HttpsError } from "firebase-functions/lib/providers/https"
import { validateAuthorization } from "../../data-access/auth/utils"
import { newRouteDAO, newTripService, newUserDao } from '../../index'
import { validateBool, validateDate, validateNumber, validateString } from "../../utils/validation"
import { validateAddRatingData, validateAddTripData } from "./validation"

/*

trip.getStartEndCoordinates({
    startPlaceID: 'EisxMDAxMDAgRWFzdCA3dGggU3RyZWV0LCBGcm9zdHByb29mLCBGTCwgVVNBIi4qLAoUChIJaS3ZL70A3YgREM-K-xXkZoUSFAoSCREHOJewAN2IEczFXw8obS9Y',
    endPlaceID: 'EihFYXN0IERyaXZlLCBNYW5oYXR0YW4sIE5ldyBZb3JrLCBOWSwgVVNBIi4qLAoUChIJq2ZCyZhYwokRQ9WxRi873TMSFAoSCWHmbgSPWMKJEYzA7PyBMgsK'
})


*/


export const getStartEndCoordinates = functions.https.onCall(async (data, context) => {

    await validateAuthorization(context)

    const startPlaceID = validateString(data.startPlaceID)
    const endPlaceID = validateString(data.endPlaceID)

    const dao = newRouteDAO()

    const startLocation = await dao.getCoordinates(startPlaceID)
    const endLocation = await dao.getCoordinates(endPlaceID)

    return {
        startLocation: { latitude: startLocation.y, longitude: startLocation.x },
        endLocation: { latitude: endLocation.y, longitude: endLocation.x }
    }

})


export const searchTrips = functions.https.onCall(async (data, context) => {

    const uid = validateAuthorization(context)

    const user = await newUserDao().getAccountData(uid)

    if (user.roles['Rider'] !== true) {
        throw new HttpsError('permission-denied', `Only a rider may search for trips.`)
    }

    const pickupLocation = {
        x: validateNumber(data.pickupLocation.x),
        y: validateNumber(data.pickupLocation.y)
    }
    const dropoffLocation = {
        x: validateNumber(data.dropoffLocation.x),
        y: validateNumber(data.dropoffLocation.y)
    }
    const passengerCount = validateNumber(data.passengerCount)
    const startAfter = validateDate(data.startDate)

    //Cut off at the end of the day.
    const startBefore = new Date(startAfter.getTime())
    startBefore.setUTCHours(23, 59, 59)

    return newTripService().searchTrips(pickupLocation, dropoffLocation, uid, passengerCount, startAfter, startBefore)

})

/*


trip.createAddedTrip({
    startTime: '2021-09-30 00:00:00.000Z', 
    startAddress: '1000 South Semoran Boulevard, Winter Park, FL, USA', 
    endAddress: 'UCF, Central Florida Blvd, Orlando, FL, USA', 
    startPlaceID: 'ChIJuT3NIohv54gR4RH6boD36So', 
    endPlaceID: 'ChIJX0kKal1o54gRq5vHs5Kb1V8', 
    seatsAvailable: 3
})

*/

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
    // console.log(data.riderID, uid)
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
        return newTripService().cancelRidebyRider(data.riderID, data.tripID)
    } else {
        throw new HttpsError('failed-precondition', 'Invalid user')
    }
})

export const deleteRidebyDriver = functions.https.onCall(async (data, context) => {

    const uid = validateAuthorization(context)
    if (uid === data.driverID) {
        return newTripService().deleteRidebyDriver(data.driverID, data.tripID)
    } else {
        throw new HttpsError('failed-precondition', 'Invalid user')
    }
})

export const cancelRiderbyDriver = functions.https.onCall(async (data, context) => {

    const uid = validateAuthorization(context)
    if (uid === data.driverID) {
        return newTripService().cancelRiderbyDriver(data.driverID, data.riderID, data.tripID)
    } else {
        throw new HttpsError('failed-precondition', 'Invalid user')
    }
})

export const declineRiderRequest = functions.https.onCall(async (data, context) => {

    const uid = validateAuthorization(context)

    if (uid === data.driverID) {
        return newTripService().declineRiderRequest(data.driverID, data.riderID, data.tripID)
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


export const getCompletedTrips = functions.https.onCall(async (data, context) => {

    const uid = validateAuthorization(context)
    const isDriver = validateBool(data.isDriver)

    if(isDriver){
    return newTripService().getDriverCompletedTrips(uid)
    }
    else{
    return newTripService().getRiderCompletedTrips(uid)
    }


})


export const riderRequestTrip = functions.https.onCall(async (data, context) => {
    const uid = validateAuthorization(context)

    if (uid) {
        return newTripService().riderRequestTrip(data.riderID, data.tripID, data.pickup, data.dropoff, data.pickupAddress, data.dropoffAddress, data.passengers)
    }
    else {
        throw new HttpsError('failed-precondition', 'Invalid User')
    }


})


export const createScheduledTrip = functions.https.onCall(async (data, context) => {

    const uid = validateAuthorization(context)

    if (uid) {
        return newTripService().createScheduledTrip(data.tripID)
    }
    else {
        throw new HttpsError('failed-precondition', 'Invalid Trip')
    }


})

export const addRiderTripRating = functions.https.onCall(async (data, context) => {

    if (data.rating === -1) {
        return `Rider: ${data.riderID} did not rate the driver`
    }

    const uid = 'Yh8L6zLsnUbhfCBbtkO43VlVhan1' //validateAuthorization(context)

    const addTripData = validateAddRatingData(data)

    if (uid === addTripData.riderID) {
        return newTripService().addRiderTripRating(addTripData.tripID, addTripData.riderID, addTripData.rating)
    } else {
        throw new HttpsError('failed-precondition', 'Invalid Trip')
    }

})


export const addDriverTripRating = functions.https.onCall(async (data, context) => {

    if (data.rating === -1) {
        return `Driver did not rate rider ${data.riderID} `
    }

    const uid = validateAuthorization(context)

    const addTripData = validateAddRatingData(data)

    if (uid === data.driverID) {
        return newTripService().addDriverTripRating(addTripData.tripID, addTripData.riderID, addTripData.rating)
    } else {
        throw new HttpsError('failed-precondition', 'Invalid Trip')
    }

})
