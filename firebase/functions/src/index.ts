// import * as functions from "firebase-functions";

// export const testMethod = functions.https.onCall((data, context) => {

//     return Promise.resolve('Test method was invoked successfully!')

// })

export function add(a: number, b: number): number {
    return a + b
}


/**
 * TODO:
 * Install and learn to use jest for TDD
 * Install dependencies:
 * - class transformer
 * - class validator
 * - axios for 3rd party apis
 * Copy over firestore encoder / decoder
 * Make DAO database interface, failing tests, implementation.
 *
 */
