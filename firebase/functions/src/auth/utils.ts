import * as functions from 'firebase-functions'
import { HttpsError } from 'firebase-functions/lib/providers/https'


/**
 * Verifies that a context contains an authenticated user's data and returns their uid if so.
 * Otherwise, an error will be thrown.
 * @param context Contextual meta data.
 * @returns The uid of the user in the context.
 */
export function validateAuthorization(context: functions.https.CallableContext): string {
    const uid = context.auth?.uid
    const isAuthenticated = uid != undefined
    if (!isAuthenticated) {
        throw new HttpsError('unauthenticated', 'Not authenticated.')
    } else {
        return uid as string
    }
}