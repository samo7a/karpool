import { classToPlain } from 'class-transformer';
import { firestore } from 'firebase-admin';

/**TODO: Make a function isntead of class since were not using state at all.
 * 
 * A helper class for transforming a class instance into a javascript object that can be sent to Firestore.
 * Class instances cannot be directly sent to Firestore. 
 */
export class FirestoreEncoder {

    /**
     * Converts any object/class to a javascript object.
     * @param obj Any object that is not an array.
     * @returns The converted javascript object.
     */
    encode<Object extends object>(obj: Object & (Object extends any[] ? "NO Arrays !" : {})): Record<string, any> {
        const object = this.convertToDeletes(classToPlain(obj))
        return object
    }

    /**
     * Recursively transforms properties in an object so it can be sent to the database.
     * @param obj Any object.
     * @returns The same object with the all fields transformed to Firestore types.
     */
    //Need to convert undefine stuff to null (could also use FieldValue.delete) because Firestore ignores undefined values
    private convertToDeletes<Object extends object>(obj: Object & (Object extends any[] ? "NO Arrays !" : {})): any {
        if (obj === undefined) {
            return null
        } else if (typeof obj === 'object' && !Array.isArray(obj)) {
            if (Object.prototype.toString.call(obj) === '[object Date]') {
                const date = obj as unknown as Date
                return firestore.Timestamp.fromDate(date)
            } else {
                const plainObj = classToPlain(obj)
                for (const key in plainObj) {
                    (plainObj as any)[key] = this.convertToDeletes((plainObj as any)[key]);
                }
                return plainObj
            }
        } else {
            return obj
        }
    }

}