

// RvZMqte9vccJ32s2T9xrt2EVZlz1

import * as functions from 'firebase-functions'
import { validateString } from './utils/validation'
import { ScheduleTripSchema } from './data-access/trip/schema'
import { autoID } from './data-access/utils/misc'
import { firestore } from 'firebase-admin'
import { FirestoreKey } from './constants'

function scheduledTrips(id: string, n: number): ScheduleTripSchema[] {
    return Array(n).fill('').map((_, i) => {

        const riders: Record<string, boolean> = {}
        riders[id] = true

        return {
            tripID: `trip-${i}`,
            driverID: id,
            duration: 0,
            vehicleID: autoID(),
            tripStatus: 'COMPLETED',
            distance: 10,
            totalCost: 100,
            startTime: new firestore.Timestamp(0, 0),
            startLocation: new firestore.GeoPoint(0, 0),
            endLocation: new firestore.GeoPoint(0, 0),
            riderInfo: [],
            ridersRateDriver: {},
            driverRatesRiders: {},
            overallRating: 0,
            polyline: '',
            riders: riders,
            startAddress: `SomeAddress ${i}`,
            endAddress: `SomeAddress ${i}`
        }
    })
}

export const createScheduleTrips = functions.https.onCall((data, context) => {

    const id = validateString(data.id)

    return Promise.all(scheduledTrips(id, data.n).map(t => {
        return firestore().collection(FirestoreKey.tripsScheduled).doc(t.tripID).set(t)
    }))


})

// function randomDate(date1: Date, date2: Date) {
//     function randomValueBetween(min, max) {
//         return Math.random() * (max - min) + min;
//     }
//     var date1 = date1 || '01-01-1970'
//     var date2 = date2 || new Date().toLocaleDateString()
//     date1 = new Date(date1).getTime()
//     date2 = new Date(date2).getTime()
//     if (date1 > date2) {
//         return new Date(randomValueBetween(date2, date1)).toLocaleDateString()
//     } else {
//         return new Date(randomValueBetween(date1, date2)).toLocaleDateString()

//     }
// }

// export const t = functions.https.onCall((data, context) => {

//     return Array(data.n).fill('').map((_, i) => {
//         const t: earnings = {
//             amount: 100,
//             tripID: 
//         }
//     })

//     return firestore().collection(FirestoreKey.users).doc(data.uid).collection(FirestoreKey.earnings).get().then(snap => {
//         return snap.docs.map(doc => doc.data()) as earnings[]
//     })
// })
