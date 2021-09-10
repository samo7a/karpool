
import * as functions from "firebase-functions"
import { validateAuthorization } from "../../auth/utils"
import { newTripService } from '../../index'
import { validateAddTripData } from "./validation"

//Create cloud function
//Authenticate using context
//Validates the data
//Implement Trip DAo method
//Implement Service method


export const createAddedTrip = functions.https.onCall(async(data, context)=>{

    const uid = validateAuthorization(context)

    const addTripData = validateAddTripData(data)

    return newTripService().createAddedTrip(uid, addTripData)  

})