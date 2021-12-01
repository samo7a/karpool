import { auth, firestore } from 'firebase-admin'
import * as functions from 'firebase-functions'
import { newAccountService, newTripService } from '.'
import { FirestoreKey } from './constants'
import { TripRiderInfo } from './data-access/trip/schema'
import { UserDAO } from './data-access/user/dao'
import { earnings } from './data-access/user/schema'
import { autoID } from './data-access/utils/misc'
import { UserRegistrationData } from './features/account-management/types'

function getRandomDate(from: Date, to: Date): Date {
    const fromTime = from.getTime();
    const toTime = to.getTime();
    return new Date(fromTime + Math.random() * (toTime - fromTime));
}

function dayOfWeek(date: Date): string {
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
    return days[date.getDay()]
}


const registerUserData = (): UserRegistrationData => {
    return {
        firstName: 'Chris',
        lastName: 'Foreman',
        gender: 'Male',
        email: 'chrisforeman2497@gmail.com',
        uid: autoID(),
        dob: '1998-05-23',
        phone: '407-516-9858',
        profilePicData: '',
        accountNum: '3399383900',
        routingNum: '998837738',
        licenseNum: 'F1653041840',
        make: 'Infiniti',
        color: 'Gray',
        isDriver: true,
        plateNum: 'Y35ATK',
        year: '2011',
        provider: 'Geico',
        coverage: '25/50/10',
        startDate: '2020-11-21',
        endDate: '2022-11-21'
    }
}

export const demo = functions.https.onCall(async (data, context) => {


    /**
     * Create 3 accounts 
     * For each account create one trip going through the riders positions
     * Of one of the accounts create them as rider too and add earnings
     * 
     */

    const info = registerUserData()

    const { uid } = await auth().createUser({
        email: info.email,
        password: 'password123',
        emailVerified: true
    })
    info.uid = uid

    await newAccountService().registerUser(info)

    await newAccountService().addRole(uid, undefined as any, 'Rider')

    const addresses: { start: string, end: string, startID: string, endID: string }[] = [
        { start: '3490 Polynesian isle blvd, Kissemme, Florida', end: '6000 hanging moss Rd, Orlando, Florida', startID: 'ChIJPVNWKrqB3YgROAmqEmMCTVA', endID: 'ChIJ65CrKmNl54gR1zV67eXSLKw' },
        { start: '2987 vineland Rd, Kissemme, Florida', end: '349 Scottsdale Square, Winter Park, Florida, USA', startID: 'EikyOTg3IFZpbmVsYW5kIFJkLCBLaXNzaW1tZWUsIEZsb3JpZGEsIFVTQSJREk8KNAoyCWEuboqigd2IEUUSazBg_8lwGh4LEO7B7qEBGhQKEglfuKumBYPdiBG6NGSyfvel3wwQqxcqFAoSCQlSIdWigd2IEY4KQ-rIgW3m', endID: 'EjAzNDkgU2NvdHRzZGFsZSBTcXVhcmUsIFdpbnRlciBQYXJrLCBGbG9yaWRhLCBVU0EiURJPCjQKMgk5XbvOhW_niBGpx7e_fiUL-RoeCxDuwe6hARoUChIJU7v_Bgpv54gRCfAvurV-a4YMEN0CKhQKEgnpJN7phW_niBGgu6vUEcXmGQ' }
    ]

    //Create trips

    const tripIDs = await Promise.all(addresses.map(addy => {
        return newTripService().createAddedTrip(uid, {
            startTime: new Date('2021-12-02T16:30:00.000Z').toISOString(),
            startAddress: addy.start,
            endAddress: addy.end,
            startPlaceID: addy.startID,
            endPlaceID: addy.endID,
            seatsAvailable: 3
        }).then(async tripID => {
            const riderArr: TripRiderInfo[] = Array(2).fill('').map(() => {
                const t: TripRiderInfo = {
                    pickupLocation: new firestore.GeoPoint(27.770675, -82.678354),
                    dropoffLocation: new firestore.GeoPoint(27.954002, -82.509439),
                    passengerCount: 1,
                    pickupIndex: 0,
                    dropoffIndex: 1,
                    riderID: autoID(),
                    pickupAddress: 'SomePickupAddress',
                    dropoffAddress: 'SomeDropOffAddress',
                    estimatedFare: Math.floor(Math.random() * 12)
                }
                return t
            })
            const estimatedTotalFare = riderArr.reduce((prev, v) => {
                return prev + v.estimatedFare
            }, 0)
            await new firestore.Firestore().collection(FirestoreKey.tripsCreated).doc(tripID).update({
                riderInfo: riderArr,
                estimatedTotalFare: estimatedTotalFare
            })
            return tripID
        })
    }))




    //Create earnings
    await Promise.all(Array(50).fill('').map(() => {
        const date = getRandomDate(new Date('2021-01-01T03:27:50.264Z'), new Date())
        const e: earnings = {
            amount: Math.floor(Math.random() * 25),
            date: firestore.Timestamp.fromDate(date),
            dayOfWeek: dayOfWeek(date),
            tripID: autoID()
        }
        return new UserDAO(new firestore.Firestore()).createEarning(uid, e)
    }))

    //Create old scheduled trips for ride history
    await Promise.all(tripIDs.map(tripID => {
        return newTripService().createScheduledTrip(tripID).then(() => {
            return new firestore.Firestore().collection(FirestoreKey.tripsScheduled).doc(tripID).update({ tripStatus: 'COMPLETED' })
        })
    }))

})


/**
 * Trip 1:
start: 3490 Polynesian isle blvd, Kissemme, Florida
end: 6000 hanging moss Rd, Orlando, Florida
Trip2:
start: 2987 vineland Rd, Kissemme, Florida
end: 349 scottsdale square, Winter Park, Florida
 */

/**
 * Rider
 * Pickup: 3250 vineland Rd, Kissimmee Florida
 * Dropoff: 2271 N Semoran Blvd, Orlando, Florida
 */
