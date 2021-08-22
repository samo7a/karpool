import * as functions from "firebase-functions";
import * as admin from 'firebase-admin'
import { RiderService } from "./rider-service";
import { DatabaseDAO } from "./database-dao";

export function add(a: number, b: number): number {
    return a + b
}

/**
 * Required at global scope to use class-transformer decorators in classes.
 * https://github.com/typestack/class-transformer
 */
import 'reflect-metadata';

admin.initializeApp()

export const registerRider = functions.https.onCall(async (data, context) => {

    const db = admin.firestore()

    console.log(data)

    await db.collection('riders').doc().set({
        firstName: 'Steven'
    })

    await db.collection('riders').doc('WfG05yO5PlgATDlZG7VN').get().then(snaphot => {
        const data = snaphot.data()
        console.log('Data', data)
    })
})


export const setupPaymentMethod = functions.https.onCall(async (data, context) => {

    //Authorize user


    const dao = new DatabaseDAO(admin.firestore())

    const service = new RiderService(dao)

    service.setupPaymentMethod('')


})

// const db = admin.firestore()

// class RiderService {

//     signupUser() {
//         db.collection('riders').doc('woCilLZETEBPChmyIqzX').update({
//             firstName: 'Chris'
//         })
//     }
// }




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


/**
 * Created user class
 * Created address class
 * Installed class-validator and class-transformer for Firestore decoder.
 * Implemented Firestore decoder/encoder for converting data correctly to/from for Firestore.
 *
 */