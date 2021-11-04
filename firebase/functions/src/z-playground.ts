

//A file to test and playaround with cloud functions.
import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'
import * as geohash from 'ngeohash'
import { hashesForPoints } from "./utils/route";
import { Constants } from "./constants";

//Test with mock only.
export const createRoute = functions.https.onCall(async (data, context) => {

    const mock = newRouteDAO()
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

    const addys: { s: string, e: string }[] = [
        { s: '5600 Laura St Zephyrhills, FL 33542', e: '605 N Stella Ave, Lakeland, FL 33801' },        //Not valid
        { s: '1206 Poinsettia Ave Orlando, FL 32804', e: '1499 Dorothy Ave E Haines City, FL 33844' }, // Not valid
        { s: '1206 Poinsettia Ave Orlando, FL 32804', e: '12520 NW 20th Ct, Miami, FL 33167' },  //Not valid
        { s: '1206 Poinsettia Ave Orlando, FL 32804', e: '1301 N 15th St, Tampa, FL 33605' }, // Valid
        { s: '1301 N 15th St, Tampa, FL 33605', e: '1206 Poinsettia Ave Orlando, FL 32804' }, // InValid
        { s: '5101 Linwood Cir, Sanford, FL 32771', e: '1062 Bella Vista Dr NE St. Petersburg, FL 33702' } //Valid


    ]

    const tripIDs = await Promise.all(addys.map(addy => {
        return newTripService().createAddedTrip('Chris', {
            startTime: '2021-09-16T03:30:05.075Z',
            startAddress: addy.s,
            endAddress: addy.e,
            seatsAvailable: 4,
            endPlaceID: addy.e,
            startPlaceID: addy.s
        })
    }))

    console.log(tripIDs)


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
// {pickupLocation: {x: -81.28721759999999, y: 28.6060022}, dropoffLocation: {x: -81.3761372, y: 28.6972963}

/*

{x: -81.3083762, y: 28.581269}, dropoffLocation: {x: -81.494272, y: 28.33599}

searchTrips({
    p1: {x: -81.3083762, y: 28.581269},
    p2: {x: -81.494272, y: 28.33599}
})
*/

export const searchTrips = functions.https.onCall((data, context) => {

    const startAfter = new Date('2021-10-25T00:00:00.000Z')

    const startBefore = new Date(startAfter.getTime())
    startBefore.setUTCHours(23, 59, 59)

    return newTripService().searchTrips(data.p1, data.p2, '', 1, startAfter, startBefore).then(response => {
        return `Found ${response.trips.length} Trips!`
    })

})

import * as decoder from 'google-polyline'
import { newPaymentService, newRouteDAO, newTripDAO, newTripService } from '.';
import { getEnv } from './utils/env-config';

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

import Stripe from 'stripe';

/*

createBank({
    routingNum: '110000000',
    accountNum: '000123456789',
    customerID: 'acct_1JqmaYIQhiMj65Oz'
})
*/

export const createBank = functions.https.onCall(async (data, context) => {

    const stripe = getEnv().stripe

    const api = new Stripe(stripe.private_key, { apiVersion: '2020-08-27' })

    return api.tokens.create({
        bank_account: {
            country: 'US',
            currency: 'usd',
            account_holder_name: 'Jenny Rosen',
            account_holder_type: 'individual',
            routing_number: data.routingNum,
            account_number: data.accountNum
        }
    }).then(res => {
        return api.customers.createSource(data.customerID, { source: res.id })
    })

})

/*
verifyBank({
    customerID: 'cus_KVnklPpALQFzvu',
    bankAccountID: 'ba_1Jqm8bJIU8d9wquzvq9YnRw0',
    amounts: [32,45]
})
*/

export const verifyBank = functions.https.onCall(async (data, context) => {

    const stripe = getEnv().stripe

    const api = new Stripe(stripe.private_key, { apiVersion: '2020-08-27' })

    await api.customers.verifySource(
        data.customerID,
        data.bankAccountID,
        { amounts: data.amounts }
    );


})


export const transfer = functions.https.onCall(async (data, context) => {

    const stripe = getEnv().stripe

    const api = new Stripe(stripe.private_key, { apiVersion: '2020-08-27' })

    return api.transfers.create({
        amount: 5,
        currency: 'usd',
        destination: 'cus_KVnklPpALQFzvu',
        transfer_group: 'ORDER_95'
    });
})



export const createConnect = functions.https.onCall(async (data, context) => {

    const stripe = getEnv().stripe
    const api = new Stripe(stripe.private_key, { apiVersion: '2020-08-27' })

    return api.accounts.create({
        type: 'express',
        country: 'US',
        email: data.email,
        capabilities: {
            card_payments: { requested: true },
            transfers: { requested: true },
            tax_reporting_us_1099_k: { requested: true }
        }
    })
})


export const onboard = functions.https.onCall(async (data, context) => {

    const stripe = getEnv().stripe
    const api = new Stripe(stripe.private_key, { apiVersion: '2020-08-27' })

    return api.accountLinks.create({
        account: data.account,
        refresh_url: 'https://example.com/reauth',
        return_url: 'https://www.karpool.xyz/',
        type: 'account_onboarding'
    });
})

export const charge = functions.https.onCall(async (data, context) => {

    return newPaymentService().chargeRider('6uvuIMaTt8Q3EL7Es2rOWR09rpF2', 100)
})

