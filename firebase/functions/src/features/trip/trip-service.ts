import { CreatedTripSchema, GeoPointSchema, ScheduleTripSchema } from "../../data-access/trip/schema";
import { TripCreationData } from "./types";
import { TripDAOInterface } from '../../data-access/trip/dao'
import { firestore } from "firebase-admin";
import { RouteDAOInterface } from "../../data-access/route/dao";
import { Point, Route } from "../../models-shared/route";
import { calculateFare, hashesForPoints } from "../../utils/route";
import * as geohasher from 'ngeohash'
import { Constants } from "../../constants";
import { HttpsError } from "firebase-functions/lib/providers/https";
import { autoID } from "../../data-access/utils/misc";
import { RiderStatus } from "../../data-access/trip/schema";
import { GeoDistance } from "../../utils/misc";

export class TripService {

    private tripDAO: TripDAOInterface

    private directionsDAO: RouteDAOInterface

    constructor(
        tripDAO: TripDAOInterface,
        directionsDAO: RouteDAOInterface
    ) {
        this.tripDAO = tripDAO
        this.directionsDAO = directionsDAO
    }

    /**
     * 
     * @param data Fields required to create a trip.
     * @returns The id of the trip document.
     */
    async createAddedTrip(uid: string, data: TripCreationData): Promise<string> {

        //Address string => (x, y) via Google Api

        const [startPoint, endPoint] = await Promise.all([
            this.directionsDAO.getCoordinates(data.startPlaceID),
            this.directionsDAO.getCoordinates(data.endPlaceID)
        ])

        const tripID = autoID()

        const route = await this.directionsDAO.getRoute(tripID, startPoint, endPoint, [])

        await this.tripDAO.createAddedTrip(tripID, {

            docID: tripID,

            driverID: uid,

            startTime: firestore.Timestamp.fromDate(new Date(data.startTime)),

            startAddress: data.startAddress,

            endAddress: data.endAddress,
            //TODO: 
            startLocation: new firestore.GeoPoint(0, 0),

            endLocation: new firestore.GeoPoint(0, 0),

            riderStatus: {},

            isOpen: true,

            riderInfo: [],

            estimatedDistance: route.distance,

            estimatedTotalFare: 0,

            estimatedDuration: route.duration,

            seatsAvailable: data.seatsAvailable,

            polyline: route.polyline

        })

        await this.setTripRoute(tripID, route)

        return tripID
    }


    /**
     * Sets the current route of a created trip.
     * @param tripID The id of the trip.
     * @param start The trip's starting point.
     * @param end THe trip's ending point.
     * @param waypoints Rider pickup and dropoff locations.
     */
    async setTripRoute(tripID: string, route: Route) {

        await this.tripDAO.removeGeoPoints(tripID)

        const geoPoints = hashesForPoints(tripID, route.getPolylinePoints(), Constants.hashPrecision)

        await this.tripDAO.addGeoPoints(geoPoints)

        //TODO: Add estimated fare, distance, duration for each rider.
        await this.tripDAO.updateCreatedTrip(tripID, {
            estimatedDistance: route.distance,
            estimatedTotalFare: 0.0
        })

    }



    /**
     * 
     * @param pickup 
     * @param dropoff 
     * @param after 
     * @param before 
     * @param passengerNum 
     * @returns 
     */
    async searchTrips(
        pickup: Point,
        dropoff: Point,
        riderID: string,
        passengerCount: number,
        after: Date,
        before: Date
    ): Promise<{ trips: CreatedTripSchema[], estimatedFare: number }> {

        const pickupHash = geohasher.encode(pickup.y, pickup.x, Constants.hashPrecision)
        const dropoffHash = geohasher.encode(dropoff.y, dropoff.x, Constants.hashPrecision)

        const [pickupPoints, dropoffPoints] = await Promise.all([
            this.tripDAO.getGeoPointsByHash(pickupHash),
            this.tripDAO.getGeoPointsByHash(dropoffHash)
        ])

        //[TripID: Point]
        const map: Record<string, GeoPointSchema> = {}

        // Create map so we have O(n) runtime.
        dropoffPoints.forEach(point => {
            map[point.tripID] = point
        })

        /**
         * Filter for trips that:
         * • Pass through both geoHash squares that contain the rider's pickup and dropoff location.
         * • Are going in the same direction as the pickup and dropoff locations.
         */
        const validTripIDs = pickupPoints.filter(pickupPoint => {
            const dropoffPoint = map[pickupPoint.tripID]
            if (dropoffPoint === undefined) { //Undefined dropoff means the trip does NOT pass through both the geoHash squares that contain the rider's pickup and dropoff points.
                return false
            }
            const sameDirection = pickupPoint.index < dropoffPoint.index
            return sameDirection
        }).map(point => point.tripID)

        //Return all trips
        const queriedTrips = await Promise.all(validTripIDs.map(tripID => this.tripDAO.getCreatedTrip(tripID)))

        /**
         * Filter trip documents that:
         * • Have not rejected the rider.
         * • Start within the target time interval.
         * • Have enough seats
         */
        const tripResults = queriedTrips.filter(trip => {
            const startTime = trip.startTime.toDate().getTime()
            const isWithinTimeInterval = startTime > after.getTime() && startTime < before.getTime()
            const hasEnoughSeats = trip.seatsAvailable >= passengerCount
            const isRejected = trip.riderStatus[riderID] !== 'Rejected'
            return hasEnoughSeats && isWithinTimeInterval && !isRejected
        })

        return {
            trips: tripResults,
            estimatedFare: calculateFare(0, 0, GeoDistance(pickup, dropoff), 1.50, 0.0)
        }

    }

    /**
     * 
     * @param driverID 
     * @returns 
     */
    async getDriverTrips(driverID: string): Promise<CreatedTripSchema[]> {
        //validate
        const driverTrips = await this.tripDAO.getDriverTrips(driverID)

        return driverTrips
    }


    /**
     * @param riderID
     * @returns scheduled trips
     */
    async getRiderTrips(riderID: string): Promise<CreatedTripSchema[]> {

        const riderTrips = await this.tripDAO.getRiderTrips(riderID)

        return riderTrips
    }




    private getWaypoints(trip: CreatedTripSchema, riderStatus: RiderStatus): Point[] {
        const points: Point[] = []
        trip.riderInfo.forEach(entry => {
            if (trip.riderStatus[entry.riderID] === riderStatus) {
                points.push({ x: entry.pickupLocation.longitude, y: entry.pickupLocation.latitude })
                points.push({ x: entry.dropoffLocation.longitude, y: entry.dropoffLocation.latitude })
            }
        })
        return points
    }


    /**
    * @param tripID
    */

    async cancelRide(riderID: string, tripID: string): Promise<void> {


        //Get trip from the database
        const trip = await this.tripDAO.getCreatedTrip(tripID)

        console.log(this.getWaypoints(trip, 'Accepted'))

        trip.riderInfo.forEach(r => {
            r.pickupLocation
        })

        // Check if trip exist in the database
        if (trip === undefined) {
            throw new HttpsError('not-found', 'Trip does not exist')
        }
        // Check if rider is part of the trip
        if (trip.riderStatus[riderID] === undefined) {
            throw new HttpsError('invalid-argument', `Rider isn't part of this ride.`)
        }

        // Cancel the rider by changing his status to Rejected. 
        // This ride will not be shown in his search
        trip.riderStatus[riderID] = 'Rejected'

        //Write to database
        await this.tripDAO.updateCreatedTrip(tripID, trip)

        // Call change route function to update route
        console.log("Rider canceled, Route will be updated")

        const scheduleTime = new Date(trip.startTime.seconds * 1000).getTime()
        const currentTime = new Date().getTime()
        const calculatedTime = ((scheduleTime - currentTime) / 1000)
        console.log(scheduleTime, "=====", currentTime, "====", calculatedTime)

        if ((calculatedTime < 10800) && (calculatedTime > 0)) {

            console.log("Rider will be fined")

            // Charge the rider $5 penality or add a field in user as debt and add the value 
        }
    }


    async acceptRiderRequest(riderID: string, tripID: string): Promise<void> {
        //get trip 
        const trip = await this.tripDAO.getCreatedTrip(tripID)
        if (trip === undefined) {
            throw new HttpsError('not-found', 'Trip does not exist')
        }
        //check if rider is in trip
        if (trip.riderStatus[riderID] === undefined) {
            throw new HttpsError('not-found', 'Rider hasnt requested a trip')
        }
        //change status to rejected
        trip.riderStatus[riderID] = 'Accepted'

        await this.tripDAO.updateCreatedTrip(tripID, trip)
        //TO DO BELOW
        //const route = await this.directionsDAO.getRoute()

        // this.setTripRoute(tripID)
        // Charge the rider $5 penality or add a field in user as debt and add the value

        //  }
    }

    async getDriverCompletedTrips(driverID: string): Promise<ScheduleTripSchema[]> {
        //get trips
        const trips = await this.tripDAO.getDriverCompletedTrips(driverID)
        //If Driver hasnt completed an trips
        if (trips === undefined) {
            throw new HttpsError('not-found', 'Driver hasnt completed a Trip')
        }
        else {
            return trips
        }
    }

    async getRiderCompletedTrips(riderID: string): Promise<ScheduleTripSchema[]> {
        //get trips
        const trips = await this.tripDAO.getRiderCompletedTrips(riderID)
        //If Driver hasnt completed an trips
        if (trips === undefined) {
            throw new HttpsError('not-found', 'Driver hasnt completed a Trip')
        }
        else {
            return trips
        }
    }
}