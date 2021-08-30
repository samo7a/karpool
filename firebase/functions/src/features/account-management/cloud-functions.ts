



import * as functions from 'firebase-functions'
import { HttpsError } from 'firebase-functions/lib/providers/https'
import { newAccountService } from '../../index'
import { validateRegistrationData } from './validation'


export const registerRider = functions.https.onCall(async (data, context) => {

    /**
     * TODO: 
     * Authorize user.
     * Validate incoming data. (DONE)
     * Use service class to register user. (DONE)
     */

    transformError(validateRegistrationData, data)

    try {
        const validData = validateRegistrationData(data)

        return newAccountService().registerRider(validData)
            .then(() => {
                return 'Rider successfully created.'
            }).catch(err => {
                return err.message
            })
    } catch (err) {
        throw new HttpsError('failed-precondition', err.message)
    }

})


function transformError<Input, Output>(closure: (input: Input) => Output, input: Input): Output {
    try {
        return closure(input)
    } catch (err) {
        throw new HttpsError('failed-precondition', err.message)
    }
}