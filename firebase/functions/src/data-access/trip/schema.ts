import { firestore } from "firebase-admin";


export type RiderStatus = 'Requested' | 'Accepted' | 'Rejected'

// type TripStatus = 'Open' | 'Closed' | 'In Progress' | 'Completed'

export interface CreatedTripSchema {

    docID: string

    /**
     * The id of the driver for the trip.
     */
    driverID: string

    /**
     * Time the trip is scheduled.
     */
    startTime: firestore.Timestamp

    /**
     * 
     */
    startLocation: firestore.GeoPoint

    endLocation: firestore.GeoPoint

    startAddress: string


    endAddress: string

    /**
 * 
 */


    /**
     * Status list of riders who have interacted with the trip.
     */
    riderStatus: Record<string, RiderStatus>


    riderInfo: TripRiderInfo[]

    /**
     * 
     */
    isOpen: boolean

    /**
     * Distance between startLocation and endLocation (Meters)
     */
    estimatedDistance: number


    /**
     * The total fare of all rider's fares in the trip.
     */
    estimatedTotalFare: number

    /**
     * The estimate duration of the entire trip. (Seconds)
     */
    estimatedDuration: number

    /**
     * Number of seats available in the trip.
     */
    seatsAvailable: number

    /**
     * 
     */
    polyline: string


}

export interface TripRiderInfo {

    pickupLocation: firestore.GeoPoint

    dropoffLocation: firestore.GeoPoint

    passengerCount: number

    pickupIndex: number

    dropoffIndex: number

    riderID: string

    pickupAddress: string

    dropoffAddress: string

    estimatedFare: number

}

export interface ScheduleTripSchema {

    /**
 * Status of trip
 */
    // status: TripStatus

    /**
     * The id of the driver for the trip.
     */
    driverID: string

    /**
     * 
     */
    riders: Record<string, boolean>


    vehicleID: string


    /**
     * 
     */
    distance: number

    /**
     * Per person 
     */
    fare: number

    /**
     * 
     */
    totalCost: number

    startTime: firestore.Timestamp

    endTime: firestore.Timestamp

    currentLocation: firestore.GeoPoint


}

export interface RiderInfoSchema {

    rating: number

    driverRating: number

    acceptTime: firestore.Timestamp

    /**
     * Number of minutes driver has to wait for the rider.
     */
    waitTime: number

    /**
     * 
     */
    pickupDistance: number


    dropoffDistance: number

    pickupLocation: firestore.GeoPoint

    dropoffLocation: firestore.GeoPoint


}

/**
 * 
 */
export interface PaymentSchema {

    uid: string

    paymentMethodID: string

    /**
     * 
     */
    baseFare: number

    bookingFee: number

    mileageRate: number

    tolls: number

    totalAmount: number

    date: firestore.Timestamp

}



export interface GeoPointSchema {

    hash: string

    index: number

    tripID: string

    x: number

    y: number
}
