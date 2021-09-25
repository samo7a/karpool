import { CreatedTripSchema, GeoPointSchema, ScheduleTripSchema } from "../../data-access/trip/schema";
import { TripCreationData } from "./types";
import { TripDAOInterface } from '../../data-access/trip/dao'
import { UserDAOInterface } from '../../data-access/user/dao'
import { firestore } from "firebase-admin";
import { RouteDAOInterface } from "../../data-access/route/dao";
import { Point, Route } from "../../models-shared/route";
import { calculateFare, hashesForPoints } from "../../utils/route";
import * as geohasher from 'ngeohash'
import { Constants } from "../../constants";
import { HttpsError } from "firebase-functions/lib/providers/https";
import { autoID } from "../../data-access/utils/misc";
<<<<<<< HEAD
import { user } from "firebase-functions/lib/providers/auth";
=======
import { RiderStatus } from "../../data-access/trip/schema";
import { distance } from "../../utils/misc";
>>>>>>> 09fa80be03b8ef123bb817166f4cc8672dc87ee7

export class TripService {

    private tripDAO: TripDAOInterface
    private userDAO: UserDAOInterface
    private directionsDAO: RouteDAOInterface

    constructor(
        userDAO: UserDAOInterface,
        tripDAO: TripDAOInterface,
        directionsDAO: RouteDAOInterface
    ) {
        this.userDAO = userDAO
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
    async searchTrips(pickup: Point, dropoff: Point, after: Date, before: Date, passengerNum: number): Promise<{ trips: CreatedTripSchema[], estimatedFare: number }> {

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

        //TODO: Remove when done debugging
        console.log(`Got ${pickupPoints.length} pickup points and ${dropoffPoints.length} dropoff points.`)
        console.log(pickupPoints.map(p => p.tripID))
        console.log(dropoffPoints.map(p => p.tripID))

        /**
         * Filter for trips that:
         * • Pass through both geoHash squares that contain the rider's pickup and dropoff location.
         * • 
         */
        const validTripIDs = pickupPoints.filter(pickupPoint => {

            const dropoffPoint = map[pickupPoint.tripID]

            if (dropoffPoint === undefined) { //Undefined dropoff means the trip does pass through both the geoHash squares that contain the rider's pickup and dropoff points.
                return false
            }

            const sameDirection = pickupPoint.index < dropoffPoint.index

            return sameDirection

        }).map(point => point.tripID)

        console.log('VALID', validTripIDs)


        //Return all trips
        const trips = await Promise.all(validTripIDs.map(tripID => this.tripDAO.getCreatedTrip(tripID)))

        const tripResults = trips.filter(trip => {
            const startTime = trip.startTime.toDate().getTime()
            const isWithinTimeInterval = startTime > after.getTime() && startTime < before.getTime()
            const hasEnoughSeats = trip.seatsAvailable >= passengerNum
            return hasEnoughSeats && isWithinTimeInterval
        })

        return {
            trips: tripResults,
            estimatedFare: calculateFare(0, 0, distance(pickup, dropoff), 1.50, 0.0)
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

    async cancelRidebyRider(riderID: string, tripID: string): Promise<void> {


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

<<<<<<< HEAD
             // chage the trip status to open
             trip.isOpen = true

            // UPdate available seats
            trip.seatsAvailable += trip.riderinfo.riderID[passengerCount]

            //UPdate estimatedTotalFaire
            trip.estimatedTotalFare -= trip.riderinfo.riderID[estimatedFare]

            //Write to database
            await this.tripDAO.updateCreatedTrip(tripID, trip)

            //ToDO: delete rider info from trip

             // ToDO: Call change route function to update route
            console.log("Rider canceled, Route will be updated")
           
            const scheduleTime = new Date(trip.startTime.seconds * 1000).getTime()
            const currentTime = new Date().getTime()
            const calculatedTime = ((scheduleTime - currentTime)/1000 )  
                console.log(scheduleTime, "=====", currentTime,"====", calculatedTime)
=======
        //Write to database
        await this.tripDAO.updateCreatedTrip(tripID, trip)

        // Call change route function to update route
        console.log("Rider canceled, Route will be updated")

        const scheduleTime = new Date(trip.startTime.seconds * 1000).getTime()
        const currentTime = new Date().getTime()
        const calculatedTime = ((scheduleTime - currentTime) / 1000)
        console.log(scheduleTime, "=====", currentTime, "====", calculatedTime)
>>>>>>> 71b2dc0fa40e8fc45817138ecb77cc61424ae17b

        if ((calculatedTime < 10800) && (calculatedTime > 0)) {

            console.log("Rider will be fined")

            // Charge the rider $5 penality or add a field in user as debt and add the value 
        }
    }

    async cancelRidebyDriver(driverID: string, riderID: string, tripID: string): Promise<void> {

        //Get trip from the database
        const trip = await this.tripDAO.getCreatedTrip(tripID)

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

             // chage the trip status to open
             trip.isOpen = true

            // UPdate available seats
            trip.seatsAvailable += trip.riderinfo.riderID[passengerCount]

            //UPdate estimatedTotalFaire
            trip.estimatedTotalFare -= trip.riderinfo.[`{riderID.}` +estimatedFare]

            //Write to database
            await this.tripDAO.updateCreatedTrip(tripID, trip)

             //ToDO: delete rider info from trip

            // ToDO: Call change route function to update route
           
           
            // Charge the driver cancelation fee  and store it in drivers account balance
            const scheduleTime = new Date(trip.startTime.seconds * 1000).getTime()
            const currentTime = new Date().getTime()
            const calculatedTime = ((scheduleTime - currentTime)/1000 )  
                console.log(scheduleTime, "=====", currentTime,"====", calculatedTime)

                if ((calculatedTime < 10800) && (calculatedTime > 0)){

                const driver =  await this.userDAO.getAccountData(driverID)

                driver.driverInfo.accountBalance -= 5 // deduct 5 dollar penalty from driver account balance 

               // TODO: call function to update the user accoutBalance.
                }    
    }


    async declineRideRequest(driverID: string, riderID: string, tripID: string): Promise<void> {

        //Get trip from the database
        const trip = await this.tripDAO.getCreatedTrip(tripID)

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

            // chage the trip status to open

            trip.isOpen = true

            // UPdate available seats
            trip.seatsAvailable += trip.riderinfo.riderID[passengerCount]

            //UPdate estimatedTotalFaire
            trip.estimatedTotalFare -= trip.riderinfo.riderID[estimatedFare]

            //Write to database
            await this.tripDAO.updateCreatedTrip(tripID, trip)

            // ToDO: Call change route function to update route
           
           // TODO: Delete rider-info from the database

           const arr  = trip.riderinfo
           arr.forEach((element, i) => {
               if (element.id = riderID){
                arr.splice(1)
               }
           });

           const res = await this.tripDAO.update({ ['riderInfo.' + riderID]: firestore.FieldValue.delete() })
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