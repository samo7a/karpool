import * as functions from "firebase-functions";
import * as admin from 'firebase-admin'

import { AuthenticationDAO } from "./auth/dao";
import { UserDAO } from "./data-access/user/dao";
import { PaymentDAO } from "./data-access/payment-dao/dao";
import { CloudStorageDAO } from "./data-access/cloud-storage/dao";
import { VehicleDAO } from "./data-access/vehicle/dao";
import { TripDAO } from "./data-access/trip/dao";
import { DirectionsDAOMock } from "./data-access/route/dao-mock";


import { AccountService } from "./features/account-management/account-service";
import { TripService } from "./features/trip/trip-service";

import { getEnv } from "./utils/env-config";

import { RouteDAO, RouteDAOInterface } from "./data-access/route/dao";

//MARK: Setup

/**
 * Required at global scope to use class-transformer decorators in classes.
 * https://github.com/typestack/class-transformer
 */
import 'reflect-metadata';

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

export function newRouteDAO(): RouteDAOInterface {
    // return new DirectionsDAOMock()
    return new RouteDAO(
        admin.firestore(),
        getEnv().directions_api.private_key
    )
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
        newUserDao(),
        newTripDAO(),
        newRouteDAO()
    )
}


//MARK: Exposed cloud function endpoints

exports.account = require('./features/account-management/cloud-functions')
exports.trip = require('./features/trip/cloud-functions')



import * as geohash from 'ngeohash'
import { hashesForPoints } from "./utils/route";
import { Constants } from "./constants";

//Test with mock only.
export const createRoute = functions.https.onCall(async (data, context) => {

    const mock = new DirectionsDAOMock()

    const arg: any = `The arguments don't matter for the mock since its static`

    const route = await mock.getRoute(arg, arg, arg, arg)

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

import { Point } from "./models-shared/route";

export const testRoute = functions.https.onCall((data, context) => {

    const start = { y: 27.721337, x: - 82.663498 }
    const end = { y: 27.905876, x: -82.292386 }

    const waypoints: Point[] = [
        { y: 27.888994, x: -82.313107 },
        { y: 27.827675, x: -82.640423 }
    ]

    return newRouteDAO().getRoute('SomeTripID', start, end, waypoints)

})

/*

searchTrips({
    p1: { y: 28.51358, x: -81.39253 },
    p2: { y: 28.08409, x:  -81.97955 }
})


*/

export const createTrips = functions.https.onCall(async (data, context) => {

    // const addys: { s: string, e: string }[] = [
    //     { s: '5600 Laura St Zephyrhills, FL 33542', e: '605 N Stella Ave, Lakeland, FL 33801' },        //Not valid
    //     { s: '1206 Poinsettia Ave Orlando, FL 32804', e: '1499 Dorothy Ave E Haines City, FL 33844' }, // Not valid
    //     { s: '1206 Poinsettia Ave Orlando, FL 32804', e: '12520 NW 20th Ct, Miami, FL 33167' },  //Not valid
    //     { s: '1206 Poinsettia Ave Orlando, FL 32804', e: '1301 N 15th St, Tampa, FL 33605' }, // Valid
    //     { s: '1301 N 15th St, Tampa, FL 33605', e: '1206 Poinsettia Ave Orlando, FL 32804' }, // InValid
    //     { s: '5101 Linwood Cir, Sanford, FL 32771', e: '1062 Bella Vista Dr NE St. Petersburg, FL 33702' } //Valid


    // ]

    // const tripIDs = await Promise.all(addys.map(addy => {
    //     return newTripService().createAddedTrip('Chris', {
    //         startTime: '2021-09-16T03:30:05.075Z',
    //         startAddress: addy.s,
    //         endAddress: addy.e,
    //         seatCount: 4
    //     })
    // }))


    // const trips = await Promise.all(tripIDs.map(tripID => { return newTripDAO().getCreatedTrip(tripID) }))

    // trips.forEach(trip => {
    //     const rawPoints = decoder.decode(trip.polyline
    //     ).map(p => ({ y: p[0], x: p[1] })) //Decoder orders coordiantes as [Lat, Long] (y, x)

    //     console.log(`Got ${rawPoints.length} points`)

    //     const geoPoints = hashesForPoints('SomeID', rawPoints, Constants.hashPrecision)

    //     let str = `lat,lng,hash`

    //     geoPoints.forEach(p => {
    //         str += `${p.y},${p.x},${p.hash}\n`
    //     })

    //     console.log("START_------------")
    //     console.log(str)
    // })

})

// import { Point } from "./models-shared/route";

export const testCache = functions.https.onCall(async (data, context) => {

    //27.721337, -82.663498

    //27.827675, -82.640423
    //27.889591, -82.311503

    //27.905876, -82.292386


    // const start = { y: 27.721337, x: - 82.663498 }
    // const end = { y: 27.905876, x: -82.292386 }

    // const waypoints: Point[] = [
    //     { y: 27.889591, x: -82.311503 },
    //     { y: 27.827675, x: -82.640423 }
    // ]

    // const route = await newRouteDAO().getRoute(start, end, waypoints)

    // const arr: Point[] = [...waypoints]
    // arr.push(start)
    // arr.push(end)

    // await newTripDAO().cacheRoute('SomeTripID', cacheID(arr), route)

    // return route
})

export const searchTrips = functions.https.onCall((data, context) => {

    return newTripService().searchTrips(data.p1, data.p2, new Date('2021-09-01T00:01:03.334Z'), new Date('2021-09-20T23:59:03.334Z'), 1).then(response => {
        return `Found ${response.trips.length} Trips!`
    })
})

import * as decoder from 'google-polyline'

export const csvPoints = functions.https.onCall(async (data, context) => {

    const docData = await admin.firestore().collection('poly').doc('poly').get().then(doc => doc.data()!)

    console.log(docData.poly)

    const rawPoints = decoder.decode(docData.poly
    ).map(p => ({ y: p[0], x: p[1] })) //Decoder orders coordiantes as [Lat, Long] (y, x)

    console.log(`Got ${rawPoints.length} points`)

    const geoPoints = hashesForPoints('SomeID', rawPoints, Constants.hashPrecision)

    let str = `lat,lng,hash`

    geoPoints.forEach(p => {
        str += `${p.y},${p.x},${p.hash}\n`
    })

    return str
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

