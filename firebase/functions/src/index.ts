import * as functions from "firebase-functions";
import * as admin from 'firebase-admin'

import { AuthenticationDAO } from "./auth/dao";
import { RiderRegistrationInfo } from "./models-shared/register";
import { HttpsError } from "firebase-functions/lib/providers/https";
import { RiderService } from "./features/rider/rider-service";
/**
 * Required at global scope to use class-transformer decorators in classes.
 * https://github.com/typestack/class-transformer
 */
import 'reflect-metadata';
import { UserDAO } from "./database/user/dao";
import { IsBoolean, IsDate, IsNumber, IsString } from "class-validator";
import { decodeDoc } from "./database/utils";

admin.initializeApp()
admin.firestore().settings({ ignoreUndefinedProperties: true })


export function validateAuthorization(context: functions.https.CallableContext): string {
    const uid = context.auth?.uid

    const isAuthenticated = uid != undefined
    if (!isAuthenticated) {
        throw new HttpsError('unauthenticated', 'Not authenticated.')
    } else {
        return uid as string
    }
}

function validateRiderInfo(data: any): RiderRegistrationInfo {
    return {
        firstName: 'Steven',
        lastName: 'J',
        gender: 'Male',
        email: 'Steven2@gmail.com',
        password: 'password',
        dob: new Date(),
        address: {
            street: 'Street 1',
            street2: undefined,
            state: 'FL',
            city: 'Orlando',
            zip: '23819'
        },
        phone: '7271920192',
        joinDate: new Date()
    }
}


function userDao(): UserDAO {
    return new UserDAO(admin.firestore())
}

function authDAO(): AuthenticationDAO {
    return new AuthenticationDAO(admin.auth())
}

function riderService(): RiderService {
    return new RiderService(
        userDao(),
        authDAO()
    )
}


export const test = functions.https.onCall((data, context) => {

    return admin.firestore().collection('test').doc('test').get().then(doc => decodeDoc(TestClass, doc)).then(c => {
        console.log(c.name)
        console.log(c.date.toISOString())
        console.log(c.bool)
        console.log(c.num)
    })
})

class TestClass {

    @IsString()
    name: string

    @IsDate()
    date: Date

    @IsBoolean()
    bool: boolean

    @IsNumber()
    num: number

    constructor(name: string, date: Date, bool: boolean, num: number) {
        this.name = name
        this.date = date
        this.bool = bool
        this.num = num
    }

}


// function validateUserInfo(data: any): string {
//     const userID = data.userID
//     if (userID === undefined) {
//         throw new HttpsError('invalid-argument', 'Must provide user id.')
//     } else {
//         return userID
//     }
// }


/**
 * Gets a user's publicly available information. 
 * Use for when a user requests another user profile.
 */
// export const getUserPublic = functions.https.onCall(async (data, context) => {

//     // validateAuthorization(context)

//     const targetUID = validateUserInfo(data)

//     const user = await dbDAO.getuserInfo(targetUID)

//     const publicInfo: UserFieldsPublic = {
//         firstName: user.firstName,
//         lastName: user.lastName,
//         phone: user.phone,
//         gender: user.gender,
//         joinDate: user.joinDate,
//         driverRating: user.driverInfo?.rating,
//         riderRating: user.riderInfo?.rating,
//         profileURL: user.profileURL
//     }

//     return publicInfo

// })


/**
 * Gets a user's information that should only be available to the user who owns the account's data.
 */
export const getUserPrivate = functions.https.onCall(async (data, context) => {

})


export const registerRider = functions.https.onCall(async (data, context) => {

    return riderService().register(validateRiderInfo(data))
        .then(() => {
            return 'Rider successfully created.'
        }).catch(err => {
            return err.message
        })


})


// export const setupPaymentMethod = functions.https.onCall(async (data, context) => {

//     //Authorize user


//     const dao = new DatabaseDAO(admin.firestore())

//     const service = new RiderService(dao)

//     service.setupPaymentMethod('')


// })

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
 * Redid database-dao class to incorporate new design.
 */