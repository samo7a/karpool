
import * as functions from "firebase-functions"
import { HttpsError } from "firebase-functions/lib/providers/https"
import { validateAuthorization } from "../../auth/utils"
import { newTripService } from '../../index'
import { validateAddTripData } from "./validation"





export const createAddedTrip = functions.https.onCall(async(data, context)=>{

    const uid = validateAuthorization(context)

    const addTripData = validateAddTripData(data)

    return newTripService().createAddedTrip(uid, addTripData)  

})

export const getDriverTrips = functions.https.onCall(async(data, context) =>{
    //validate who is calling function ???
    validateAuthorization(context)
    return  newTripService().getDriverTrips(data)
})

export const getRiderTrips = functions.https.onCall(async (data, context) =>{

        const uid = validateAuthorization(context)
        
        if(uid){
            return newTripService().getRiderTrips(data)
        } else{
            throw new HttpsError('failed-precondition', 'Invalid user')
        }

        
    })

export const cancelRidebyRider = functions.https.onCall(async (data, context) => {

        const uid = validateAuthorization(context)

        if(uid){
           return  newTripService().cancelRide(data.riderID, data.tripID)
        }else{
            throw new HttpsError('failed-precondition', 'Invalid user') 
        }
})


export const declineRiderRequest = functions.https.onCall(async (data, context) =>{
        const uid = validateAuthorization(context)

         if(uid){
             return newTripService().declineRiderRequest(data.riderID, data.tripID)
         }
        else{
             throw new HttpsError('failed-precondition', 'Invalid user')
         }
})


export const acceptRiderRequest = functions.https.onCall(async (data, context) =>{
     const uid = validateAuthorization(context)

     if(uid){


         return newTripService().acceptRiderRequest(data.riderID, data.tripID)
     }
     else{
         throw new HttpsError('failed-precondition', 'Invalid User')
     }
})

export const getDriverCompletedTrips = functions.https.onCall(async (data, context)=>{
    const uid = validateAuthorization(context)
    if(uid){
        return newTripService().getDriverCompletedTrips(data.driverID)
    }
    else{
        throw new HttpsError('failed-precondition','Invalid User')
    }
})

export const getRiderCompletedTrips = functions.https.onCall(async (data, context)=>{
    //NOT WORKING 
    return newTripService().getDriverCompletedTrips(data.riderID)
})