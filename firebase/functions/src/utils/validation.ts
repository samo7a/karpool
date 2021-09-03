import { HttpsError } from "firebase-functions/lib/providers/https"

/**
 * Checks if the given value is string. If not a string an error is thrown.
 * @param value Any value
 * @returns A string
 */
export function validateString(value: any, propName?: string): string {
    if (typeof value !== 'string') {
        if (propName) {
            throw new HttpsError('failed-precondition', `Expected ${propName} to be a string but found ${typeof value}.`)
        } else {
            throw new HttpsError('failed-precondition', `Validation failed: ${typeof value} is not a string.`)
        }
    } else {
        return value
    }
}

/**
 * Checks if the given value is string or undefined. If not a string an error is thrown.
 * @param value Any value
 * @returns A string or undefined
 */
export function validateStringOptional(value: any, propName?: string): string | undefined {
    if (typeof value !== 'string' && value !== undefined) {
        if (propName) {
            throw new HttpsError('failed-precondition', `Expected ${propName} to be an optional string but found ${typeof value}.`)
        } else {
            throw new HttpsError('failed-precondition', `Validation failed: ${typeof value} is not an optional string.`)
        }
    } else {
        return value
    }
}


/**
 * Checks if a given value is an array where each element is a string. 
 * An error is thrown otherwise
 * @param value Any value
 * @returns An array of strings
 */
export function validateStringArray(value: any): string[] {
    if (!Array.isArray(value)) {
        throw new HttpsError('failed-precondition', `Validation failed: ${typeof value} is not a string array.`)
    }
    value.forEach(element => {
        if (typeof element !== 'string') {
            throw new HttpsError('failed-precondition', `Validation failed: Non-string element was found in the array.`)
        }
    })
    return value
}

/**
 * Checks if a given value is a boolean. If not a boolean an error is thrown.
 * @param value Any value
 * @returns A boolean
 */
export function validateBool(value: any): boolean {
    if (typeof value !== 'boolean') {
        throw new HttpsError('failed-precondition', `Validation failed: ${typeof value} is not a boolean.`)
    } else {
        return value
    }
}

/**
 * Checks if a given value is a number. If not a number an error is thrown.
 * @param value Any value
 * @returns A number
 */
export function validateNumber(value: any): number {
    if (isNaN(Number(value))) {
        throw new HttpsError('failed-precondition', `Validation failed: ${value} is Nan.`)
    } else {
        return Number(value)
    }
}

/**
 * Checks if a given value is a date representable. If not, an error is thrown.
 * @param value Any value
 * @returns A date
 */
export function validateDate(value: any): Date {
    const d = new Date(value)
    if (((d as any) !== 'Invalid Date') && !isNaN((d as any))) {
        return new Date(value)
    } else {
        throw new HttpsError('failed-precondition', `Validation failed: ${typeof value} is not convertible to Date.`)
    }
}