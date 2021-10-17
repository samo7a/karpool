import { firestore } from "firebase-admin";


export type RiderStatus = 'Requested' | 'Accepted' | 'Rejected'

export type tripStatus = 'COMPLETED' | 'STARTED'


export interface FCMTokens {
    tokenIDs: string[]
}

// type TripStatus = 'Open' | 'Closed' | 'In Progress' | 'Completed'

/**
 * 
 * Database implementation 
 */

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

    /**
     * 
     */
    notifThree?: boolean

    /**
     * 
     */
    notifThirty?: boolean

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

    tripID: string

    /**
     * The id of the driver for the trip.
     */
    driverID: string

    duration: number

    vehicleID: string

    tripStatus: tripStatus

    /**
     * 
     */
    distance: number

    /**
     * 
     */
    totalCost: number

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
  
  
    riderInfo: TripRiderInfo[]

    /**
     * Store all ratings related to
     * driver and riders in a trip
     */

    ridersRateDriver: Record<string, number>

    driverRatesRiders: Record<string, number>

    overallRating: number
  
    /**
     * 
    */
    polyline: string
  
      
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


export interface NotificationData {

    subject: string,

    tripID: string,

    driverID: string,

    notificationID: number
}
