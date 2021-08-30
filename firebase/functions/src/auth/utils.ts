import * as functions from 'firebase-functions'
import { HttpsError } from 'firebase-functions/lib/providers/https'


export function validateAuthorization(context: functions.https.CallableContext): string {
    const uid = context.auth?.uid
    const isAuthenticated = uid != undefined
    if (!isAuthenticated) {
        throw new HttpsError('unauthenticated', 'Not authenticated.')
    } else {
        return uid as string
    }
}