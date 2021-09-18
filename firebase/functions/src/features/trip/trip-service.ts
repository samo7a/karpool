import { CreatedTripSchema, GeoPointSchema, ScheduleTripSchema } from "../../data-access/trip/schema";
import { TripCreationData } from "./types";
import { TripDAOInterface } from '../../data-access/trip/dao'
import { firestore } from "firebase-admin";
import { DirectionsDAOInterface } from "../../data-access/directions/dao";
import { Point, Route } from "../../models-shared/route";
import { hashesForPoints } from "../../geo-hash";
import * as geohasher from 'ngeohash'
import { Constants } from "../../constants";
import { HttpsError } from "firebase-functions/lib/providers/https";

export class TripService {

    private tripDAO: TripDAOInterface

    private directionsDAO: DirectionsDAOInterface

    constructor(
        tripDAO: TripDAOInterface,
        directionsDAO: DirectionsDAOInterface
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
        const route = await this.directionsDAO.getRoute(data.startAddress, data.endAddress, undefined)

        const tripID = await this.tripDAO.createAddedTrip({
            driverID: uid,

            startTime: firestore.Timestamp.fromDate(new Date(data.startTime)),

            startLocation: data.startAddress,

            riderStatus: {},

            isOpen: true,

            estimatedDistance: route.distance,

            estimatedFare: 0,

            estimatedDuration: route.duration,

            seatsAvailable: data.seatCount

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

        const rawPoints = route.legs.map(leg => leg.steps.map(step => step.startPoint)).flatMap(arr => arr)

        const geoPoints = hashesForPoints(tripID, rawPoints, Constants.hashPrecision)

        await this.tripDAO.addGeoPoints(geoPoints)

        //TODO: Add estimated fare, distance, duration for each rider.
        await this.tripDAO.updateCreatedTrip(tripID, {
            estimatedDistance: route.distance,
            estimatedFare: 0.0
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
    async searchTrips(pickup: Point, dropoff: Point, after: Date, before: Date, passengerNum: number): Promise<CreatedTripSchema[]> {

        //Get hash of pickup point
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

        const validTripIDs = pickupPoints.filter(pickupPoint => {

            const dropoffPoint = map[pickupPoint.tripID]

            const existsInBoth = dropoffPoint !== undefined

            const sameDirection = pickupPoint.index < dropoffPoint.index

            return existsInBoth && sameDirection

        }).map(point => point.tripID)


        //Return all trips
        const trips = await Promise.all(validTripIDs.map(tripID => this.tripDAO.getCreatedTrip(tripID)))

        return trips.filter(trip => {
            const startTime = trip.startTime.toDate().getTime()
            const isWithinTimeInterval = startTime > after.getTime() && startTime < before.getTime()
            const hasEnoughSeats = trip.seatsAvailable >= passengerNum
            return hasEnoughSeats && isWithinTimeInterval
        })

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
     * 
     * @param riderID 
     * @returns 
     */
    async getRiderTrips(riderID: string): Promise<CreatedTripSchema[]> {

        const riderTrips = await this.tripDAO.getRiderTrips(riderID)

        return riderTrips
    }


    /**
     * 
     * @param riderID 
     * @param tripID 
     */

    async cancelRide(riderID: string, tripID: string): Promise<void> {

        //Read from database

        const trip = await this.tripDAO.getCreatedTrip(tripID)

            if (trip.riderStatus[riderID] === undefined) {
                throw new HttpsError('invalid-argument', `Rider isn't part of this ride.`)
            }
            trip.riderStatus[riderID] = 'Rejected'

            //Write to database
        await this.tripDAO.updateCreatedTrip(tripID, trip)

            // Call change route function to update route
            console.log("Rider canceled, Route will be updated")

            //Do logic
            const scheduleTime = new Date(trip.startTime.seconds * 1000).getTime()
            const currentTime = new Date().getTime()

                if (((currentTime - scheduleTime) /1000 ) < 10800 ){

                    console.log("Rider will be fined")

                    // Charge the rider $5 penality or add a field in user as debt and add the value

                }    
    }


    async declineRiderRequest (riderID: string, tripID: string): Promise<void>{
        //get trip 
        const trip = await this.tripDAO.getCreatedTrip(tripID)
        if(trip == undefined){
            throw new HttpsError('not-found','Trip does not exist')
        }
        //check if rider is in trip
        if(trip.riderStatus[riderID] == undefined){
            throw new HttpsError('not-found','Rider hasnt requested a trip')
        }
        //change status to rejected
        trip.riderStatus[riderID] = 'Rejected'


        await this.tripDAO.updateCreatedTrip(tripID, trip)

    }

    async acceptRiderRequest (riderID: string, tripID: string): Promise<void>{
        //get trip 
        const trip = await this.tripDAO.getCreatedTrip(tripID)
        if(trip == undefined){
            throw new HttpsError('not-found','Trip does not exist')
        }
        //check if rider is in trip
        if(trip.riderStatus[riderID] == undefined){
            throw new HttpsError('not-found','Rider hasnt requested a trip')
        }
        //change status to rejected
        trip.riderStatus[riderID] = 'Accepted'
        
        await this.tripDAO.updateCreatedTrip(tripID, trip)
        //TO DO BELOW
        //const route = await this.directionsDAO.getRoute()

       // this.setTripRoute(tripID)
    }

    async getDriverCompletedTrips(driverID: string): Promise<ScheduleTripSchema[]>{
        //get trips
        const trips = await this.tripDAO.getDriverCompletedTrips(driverID)
        //If Driver hasnt completed an trips
        if(trips == undefined){
            throw new HttpsError('not-found','Driver hasnt completed a Trip')
        }
        else{
             return trips 
        }
    }

    async getRiderCompletedTrips(riderID: string): Promise<ScheduleTripSchema[]>{
        //get trips
        const trips = await this.tripDAO.getDriverCompletedTrips(riderID)
        //If Driver hasnt completed an trips
        if(trips == undefined){
            throw new HttpsError('not-found','Driver hasnt completed a Trip')
        }
        else{
            return trips
        }
    }
}
