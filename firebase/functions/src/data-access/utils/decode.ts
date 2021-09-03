
import { ClassTransformOptions, plainToClass } from 'class-transformer';
import { HttpsError } from 'firebase-functions/lib/providers/https';
import { validate } from 'class-validator';


/**
 * This type restricts the parameters to class-only types.
 */
type AClassType<T> = {
    new(...args: any[]): T;
};

/**
 * A method for decoding a Firestore document to an instance of a Javascript class.
 * @param cls The class to instantiate.
 * @param snapshot The data snapshot returned from Firestore.
 * @param options Transformation options.
 * @returns A class instance.
 */
export async function fireDecode<T>(cls: AClassType<T>, document: FirebaseFirestore.DocumentSnapshot, options?: ClassTransformOptions): Promise<T> {
    if (!document.exists) {
        throw new HttpsError('not-found', `Cannot decode document at ${document.ref.path} because it doesn't exist.`)
    } else if (!document.data()) {
        throw new HttpsError('data-loss', `Cannot decode document at ${document.ref.path} because it doesn't have any data.`)
    }

    const transformed = transformFirestoreTypes(Object.assign({}, document.data()))

    const object = plainToClass(cls, transformed) as unknown as object

    const errArr = await validate(object)

    if (errArr.length > 0) {
        throw new HttpsError('internal', `Failed to decode document referenced from: ${document.ref.path}. Reason: ${errArr[0].toString()}.`)
    }

    return object as unknown as T
}


/**
 * Recursively transforms all nested properties that are Firestore types, such as Timestamp, to native javscript types.
 * @param obj Any object.
 * @returns An object where all properties have been converted.
 */
function transformFirestoreTypes(obj: any): any {
    Object.keys(obj).forEach(key => {
        if (!obj) { //Null and undefined will be left alone.
            return
        } else if (typeof obj[key] === 'object' && 'toDate' in obj[key]) {
            obj[key] = obj[key].toDate()
        } else if (obj[key].constructor.name === 'GeoPoint') {
            const { latitude, longitude } = obj[key]
            obj[key] = { latitude, longitude }
        } else if (obj[key].constructor.name === 'DocumentReference') {
            const { id, path } = obj[key]
            obj[key] = { id, path }
        } else if (typeof obj[key] === 'object') {
            transformFirestoreTypes(obj[key])
        }
    })
    return obj
}