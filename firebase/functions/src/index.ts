import * as functions from "firebase-functions";
import * as admin from 'firebase-admin'
import { AuthenticationDAO } from "./auth/dao";
import { UserDAO } from "./data-access/user/dao";
import { PaymentDAO } from "./data-access/payment-dao/dao";
import { CloudStorageDAO } from "./data-access/cloud-storage/dao";
import { VehicleDAO } from "./data-access/vehicle/dao";
import { TripDAO } from "./data-access/trip/dao";
import { DirectionsDAOMock } from "./data-access/directions/dao-mock";
import { AccountService } from "./features/account-management/account-service";
import { TripService } from "./features/trip/trip-service";
import { getEnv } from "./env-config";

//MARK: Setup

/**
 * Required at global scope to use class-transformer decorators in classes.
 * https://github.com/typestack/class-transformer
 */
import 'reflect-metadata';
import { DirectionsDAOInterface } from "./data-access/directions/dao";

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
    return new TripDAO(admin.firestore(), admin.database())
}

export function newDirectionsDAO(): DirectionsDAOInterface {
    return new DirectionsDAOMock()
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
        newTripDAO(),
        newDirectionsDAO()
    )
}


//MARK: Exposed cloud function endpoints

exports.account = require('./features/account-management/cloud-functions')
exports.trip = require('./features/trip/cloud-functions')



import * as geohash from 'ngeohash'

//Test with mock only.
export const createRoute = functions.https.onCall(async (data, context) => {

    const mock = new DirectionsDAOMock()

    const arg: any = `The arguments don't matter for the mock since its static`

    const route = await mock.getRoute(arg, arg, arg)

    const allPoints: { x: number, y: number }[] = []

    route.legs.forEach(leg => {
        leg.steps.forEach(step => {
            allPoints.push(step.startPoint)
            allPoints.push(step.endPoint)
        })
    })

    const hashes: string[] = [...new Set(route.legs.map(l => l.steps.map(s => geohash.encode(s.startPoint.y, s.startPoint.x, 5))).flatMap(arr => arr))]

    return {
        points: allPoints.length,
        hashes: hashes
    }

})


export const testAdd = functions.https.onCall(async (data, context) => {
    return newTripDAO().addGeoPoints([
        {
            "x": -82.8281804,
            "y": 27.8436234,
            index: 0,
            tripID: data.tripID,
            hash: 'someHash'
        },
        {
            "x": -82.8281804,
            "y": 27.8436234,
            index: 1,
            tripID: data.tripID,
            hash: 'someHash'
        },
        {
            "x": -82.8281817,
            "y": 27.8436907,
            index: 2,
            tripID: data.tripID,
            hash: 'someHash'
        },
        {
            "x": -82.8281817,
            "y": 27.8436907,
            index: 3,
            tripID: data.tripID,
            hash: 'someHash'
        }
    ])
})


export const testRemove = functions.https.onCall(async (data, context) => {

    return newTripDAO().removeGeoPoints(data.tripID)

})

