import * as functions from "firebase-functions";
import * as admin from 'firebase-admin'
import { AuthenticationDAO } from "./auth/dao";
import { UserDAO } from "./data-access/user/dao";


//MARK: Setup

/**
 * Required at global scope to use class-transformer decorators in classes.
 * https://github.com/typestack/class-transformer
 */
import 'reflect-metadata';
import { PaymentDAO } from "./data-access/payment-dao/dao";
import { getEnv } from "./env-config";
import 'reflect-metadata';
import { AccountService } from "./features/account-management/account-service";
import { CloudStorageDAO } from "./data-access/cloud-storage/dao";
import { VehicleDAO } from "./data-access/vehicle/dao";
import { TripDAO } from "./data-access/trip/dao";
import { TripService } from "./features/trip/trip-service";

admin.initializeApp()
admin.firestore().settings({ ignoreUndefinedProperties: true })


/**
 * MARK: Classes shared around the system.
 */

export function newUserDao(): UserDAO {
    return new UserDAO(admin.firestore())
}

export function newAuthDAO(): AuthenticationDAO {
    return new AuthenticationDAO(admin.auth())
}

export function newCloudStorageDAO(): CloudStorageDAO {
    return new CloudStorageDAO(admin.storage())
}

export function newVehicleDAO(): VehicleDAO {
    return new VehicleDAO(admin.firestore())
}

export function newPaymentDAO(): PaymentDAO {
    const stripe = getEnv().stripe
    return new PaymentDAO(stripe.public_key, stripe.private_key)
}


export function newTripDAO(): TripDAO {
    return new TripDAO(admin.firestore())
}

export function newAccountService(): AccountService {
    return new AccountService(
        newUserDao(),
        newAuthDAO(),
        newCloudStorageDAO(),
        newVehicleDAO(),
        newPaymentDAO()
    )
}

export function newTripService(): TripService {
    return new TripService(
        newTripDAO()

    )
}


//MARK: Exposed cloud function endpoints


// { 'firstName': 'Chris', 'lastName': 'Foreman', 'gender': 'Male', 'email': 'Chris1134@gmail.com', 'password': 'Somepassword', 'dob': new Date(), 'phone': '12341234123412', 'cardNum': '0101', 'cardExpDate': '9/22', 'cardCVC': '123', 'stripeToken': 'asldkfja;lfkja;sldfkjads;lfjkasd', 'profilePicData': 'asdfadsf', 'isDriver': false }



exports.account = require('./features/account-management/cloud-functions')
exports.trip = require('./features/trip/cloud-functions')



//MARK: Experimental: Delete later.

export const test2 = functions.https.onCall(async (data, context) => {

    console.log('Client Data', data)

    const res = await admin.firestore().collection('what ever the fuck you want').doc().set({
        firstName: 'Chris',
        age: 23
    })

    return res
})

export const test = functions.https.onCall((data, context) => {

    // return admin.firestore().collection('test').doc('test').get().then(doc => fireDecode(TestClass, doc)).then(c => {
    // console.log(c.name)
    // console.log(c.date.toISOString())
    // console.log(c.bool)
    // console.log(c.num)
    // })
    return Promise.resolve({
        firstname: "Taoufik"
    })
})


// class TestClass {

//     @IsString()
//     name: string

//     @IsDate()
//     date: Date

//     @IsBoolean()
//     bool: boolean

//     @IsNumber()
//     num: number

//     constructor(name: string, date: Date, bool: boolean, num: number) {
//         this.name = name
//         this.date = date
//         this.bool = bool
//         this.num = num
//     }

// }