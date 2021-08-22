
import { firestore } from 'firebase-admin'

export function autoID(): string {
    return firestore().collection('collection').doc().id
}