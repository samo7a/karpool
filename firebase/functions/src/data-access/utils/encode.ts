
import { firestore } from 'firebase-admin';


/**
 * 
 * @param obj 
 * @returns 
 */
export function fireEncode<Object extends object>(obj: Object & (Object extends any[] ? "NO Arrays !" : {})): Record<string, any> {
    const plain = Object.assign({}, obj) //Convert to plain object in case obj is class.
    return convertTypes(plain)
}


/**
 * This method is for converting javascript types to Firestore types.
 * Since we want to be able to specify if a field should still exist in the database. This converts 
 * undefined fields to .delete() value types so that any fields explicity set as undefined, will be
 * removed from the database. 
 * NOTE: A null field will be set to null in Firestore.
 * @param obj 
 * @returns 
 */
function convertTypes<T extends object>(obj: Object & (Object extends any[] ? "NO Arrays !" : {})): any {
    if (obj === undefined || obj === null) {
        return obj
    } else if (typeof obj === 'object' && obj !== null && !Array.isArray(obj)) {
        if (Object.prototype.toString.call(obj) === '[object Date]') {
            const date = obj as unknown as Date
            return firestore.Timestamp.fromDate(date)
        } else {
            const plainObj = Object.assign({}, obj)
            for (const key in plainObj) {
                (plainObj as any)[key] = convertTypes((plainObj as any)[key]);
            }
            return plainObj
        }
    } else {
        return obj
    }
}
