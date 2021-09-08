import { firestore } from "firebase-admin";


type RiderStatus = 'Requested' | 'Accepted' | 'Rejected'

// type TripStatus = 'Open' | 'Closed' | 'In Progress' | 'Completed'

export interface CreatedTripSchema {

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

    /**
     * Status list of riders who have interacted with the trip.
     */
    riderStatus: Record<string, RiderStatus>

    /**
     * 
     */
    isOpen: boolean

    /**
     * Distance between startLocation and endLocation
     */
    estimatedDistance: number


    /**
     * The estimated amount each rider will pay.
     */
    estimatedFare: number

    /**
     * Number of seats available in the trip.
     */
    seatCount: number

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