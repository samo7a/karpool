import { ClassTransformOptions, plainToClass } from 'class-transformer';
import { validate } from 'class-validator';
import { HttpsError } from 'firebase-functions/lib/providers/https';

/**
 * This type allows the parameters to be restricted to class-only types in the Firstore-Decoder.
 */
export declare type AClassType<T> = {
    new(...args: any[]): T;
};

/**
 * A helper class for transforming data retrieved from Firestore into class instances.
 */
export class FirestoreDecoder {

    /**
     * Recursively transforms all nested properties that are Firestore types, such as Timestamp, to native javscript types.
     * @param obj Any object.
     * @returns An object where all properties have been converted.
     */
    private transformFirestoreTypes(obj: any): any {
        Object.keys(obj).forEach(key => {
            if (!obj[key]) return
            if (typeof obj[key] === 'object' && 'toDate' in obj[key]) {
                obj[key] = obj[key].toDate()
            } else if (obj[key].constructor.name === 'GeoPoint') {
                const { latitude, longitude } = obj[key]
                obj[key] = { latitude, longitude }
            } else if (obj[key].constructor.name === 'DocumentReference') {
                const { id, path } = obj[key]
                obj[key] = { id, path }
            } else if (typeof obj[key] === 'object') {
                this.transformFirestoreTypes(obj[key])
            }
        })
        return obj
    }


    /**
     * Decodes data formatted from the Firstore to an to a class instance using native Javscript types.
     * @param cls The class type to instantiate.
     * @param data The data that will be used to instantiate the class.
     * @param options Options during the transformation.
     * @returns A class instance.
     */
    async decode<T>(cls: AClassType<T>, data: any, options?: ClassTransformOptions): Promise<T> {
        const transformed = this.transformFirestoreTypes(data)
        const object = plainToClass(cls, transformed) as unknown as object

        const errArr = await validate(object)
        if (errArr.length > 0) {
            throw new HttpsError('internal', errArr[0].toString())
        }
        return object as unknown as T
    }

    /**
     * A convenience method for decoding a Firestore document to a Javascript class.
     * @param cls The class to instantiate.
     * @param snapshot The data snapshot returned from Firestore.
     * @param options Transformation options.
     * @returns A class instance.
     */
    async decodeDoc<T>(cls: AClassType<T>, snapshot: FirebaseFirestore.DocumentSnapshot, options?: ClassTransformOptions): Promise<T> {
        if (!snapshot.exists) {
            throw new HttpsError('not-found', `Cannot decode document at ${snapshot.ref.path} because it doesn't exist.`)
        } else if (!snapshot.data()) {
            throw new HttpsError('data-loss', `Cannot decode document at ${snapshot.ref.path} because it doesn't have any data.`)
        }
        return this.decode(cls, snapshot.data())
    }

}