import * as functions from "firebase-functions";

export const testMethod = functions.https.onCall((data, context) => {

    return Promise.resolve('Test method was invoked successfully!')

})

/**
 * TODO:
 * Setup dev and production environment and gitignore the service account file
 * Setup package.json scripts for switching environments
 *
 */
