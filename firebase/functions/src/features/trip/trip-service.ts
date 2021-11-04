import { CreatedTripSchema, GeoPointSchema, RiderStatus, ScheduleTripSchema, TripRiderInfo } from "../../data-access/trip/schema";
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
import { GeoDistance } from "../../utils/misc";
import { UserSchema } from "../../data-access/user/schema";
import { sendCustomNotification } from "../../features/notifications/notifications";
import { NotificationsDAOInterface } from "../../features/notifications/notificationsDAO";
import { VehicleDAOInterface } from "../../data-access/vehicle/dao";

//TODO:  
//  create a cloud function to add deviceToken to FCMTokens collection
//       finish the notification for delete, add, join, decline and, cancel a ride

//Later: ad notificatrions for 3  and at the trip's start time

export class TripService {

    private tripDAO: TripDAOInterface
    private directionsDAO: RouteDAOInterface
    private notificationsDAO: NotificationsDAOInterface
    private vehicleDAO: VehicleDAOInterface
    userDAO: any;

    constructor(
        userDAO: UserDAOInterface,
        tripDAO: TripDAOInterface,
        directionsDAO: RouteDAOInterface,
        notificationsDAO: NotificationsDAOInterface,
        vehicleDAO: VehicleDAOInterface
    ) {
        this.userDAO = userDAO
        this.tripDAO = tripDAO
        this.directionsDAO = directionsDAO
        this.notificationsDAO = notificationsDAO
        this.vehicleDAO = vehicleDAO
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
            startLocation: new firestore.GeoPoint(startPoint.y, startPoint.x),

            endLocation: new firestore.GeoPoint(endPoint.y, endPoint.x),

            riderStatus: {},

            isOpen: true,

            riderInfo: [],

            estimatedDistance: route.distance,

            estimatedTotalFare: 0,

            estimatedDuration: route.duration,

            seatsAvailable: data.seatsAvailable,

            polyline: route.polyline,

            notifThirty: false,

            notifThree: false

        })

        await this.setTripRoute(tripID, route)

        return tripID
    }


    async createScheduledTrip(tripID: string): Promise<String> {

        const trip = await this.tripDAO.getCreatedTrip(tripID)

        const car = await this.vehicleDAO.getVehicle(trip.driverID)

        const riders: Record<string, boolean> = {} 
        trip.riderInfo.forEach(r => riders[r.riderID]= true)

        await this.tripDAO.createScheduledTrip(tripID, {

            tripID: trip.docID,

            driverID: trip.driverID,

            vehicleID: car.id,

            startTime: trip.startTime,

            startAddress: trip.startAddress,

            endAddress: trip.endAddress,

            startLocation: trip.startLocation,

            endLocation: trip.endLocation,

            tripStatus: 'STARTED',

            riderInfo: trip.riderInfo,

            distance: trip.estimatedDistance,

            totalCost: trip.estimatedTotalFare,

            duration: trip.estimatedDuration,

            ridersRateDriver: {},

            driverRatesRiders: {},

            overallRating: 0,

            polyline: trip.polyline,

            riders: riders

        })

        const tripIDs: string[] = []
        const snapshot = trip.riderInfo

        snapshot.forEach((element) => {
            tripIDs.push(element.riderID)
        })

        const tokens = await this.notificationsDAO.getTokenList(tripIDs)

        //console.log(tokens)
        const message = {
            subject: "The driver is heading toward your location for pickup",
            driverID: trip.driverID,
            tripID: tripID,
            notificationID: 3
        }

        sendCustomNotification(tokens, message)

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

        // const pickupTrips = pickupPoints.map(p => p.tripID)
        // const dropoffTrips = pickupPoints.map(p => p.tripID)

        // console.log(pickupTrips)
        // console.log(dropoffTrips)

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
        const queriedTrips: CreatedTripSchema[] = []

        await Promise.all(validTripIDs.map(async tripID => {
            await this.tripDAO.getCreatedTrip(tripID).then(trip => {
                queriedTrips.push(trip)
            }).catch(err => {
                console.log(err.message)
            })
        }))

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
            const isRejected = trip.riderStatus[riderID] === 'Rejected'

            console.log(trip.startTime.toDate().toISOString(), after.toISOString(), before.toISOString(), hasEnoughSeats, isWithinTimeInterval, isRejected)
            return hasEnoughSeats && isWithinTimeInterval && !isRejected
        })

        const meters = GeoDistance(pickup, dropoff)
        return {
            trips: tripResults,
            estimatedFare: calculateFare(0, 0, meters / 1600, 1.50, 0.0)
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
     * @param riderID
     * @param tripID 
     */
    async cancelRidebyRider(riderID: string, tripID: string): Promise<void> {

        //Get trip from the database
        const trip = await this.tripDAO.getCreatedTrip(tripID)

        // Check if rider is part of the trip
        if (trip.riderStatus[riderID] === undefined) {
            throw new HttpsError('invalid-argument', `Rider isn't part of this ride.`)
        } else if (trip.riderStatus[riderID] === 'Rejected') {
            throw new HttpsError('invalid-argument', `Rider has already cancelled this ride.`)
        }

        // Cancel the rider by changing his status to Rejected. 
        // This ride will not be shown in his search
        trip.riderStatus[riderID] = 'Rejected'

        // chage the trip status to open
        trip.isOpen = true

        const rider = trip.riderInfo.filter(e => e.riderID === riderID)[0]
        // UPdate available seats
        //console.log(rider)
        trip.seatsAvailable += rider.passengerCount

        // Call change route function to update route
        const wayPoints = this.getWaypoints(trip, 'Accepted')
        const startLoc = { x: trip.startLocation.longitude, y: trip.startLocation.latitude }
        const endLoc = { x: trip.endLocation.longitude, y: trip.endLocation.latitude }
        const newRoute = this.directionsDAO.getRoute(tripID, startLoc, endLoc, wayPoints)
        trip.polyline = (await newRoute).polyline

        //delete rider info from trip
        const arr = trip.riderInfo
        arr.slice().reverse().forEach((element) => {
            if (element.riderID === riderID) {
                arr.splice(1);
            }
        });
        trip.riderInfo = arr

        //Write to database
        await this.tripDAO.updateCreatedTrip(tripID, trip)

        const scheduleTime = new Date(trip.startTime.seconds * 1000).getTime()
        const currentTime = new Date().getTime()
        const calculatedTime = ((scheduleTime - currentTime) / 1000)
        // console.log(scheduleTime, "=====", currentTime, "====", calculatedTime)

        if ((calculatedTime < 10800) && (calculatedTime > 0)) {

            console.log("Rider will be fined")

            //TODO: Charge the rider $5 penality or add a field in user as debt and add the value 
        }

        const token = await this.notificationsDAO.getTokenList([trip.driverID])

        const message = {
            subject: "One of the riders canceled your trip",
            driverID: trip.driverID,
            tripID: tripID,
            notificationID: 1
        }

        sendCustomNotification(token, message)


    }

    async cancelRiderbyDriver(driverID: string, riderID: string, tripID: string): Promise<void> {

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

        const rider = trip.riderInfo.filter(e => e.riderID === riderID)[0]
        // UPdate available seats
        trip.seatsAvailable += rider.passengerCount

        // Call change route function to update route
        const wayPoints = this.getWaypoints(trip, 'Accepted')
        const startLoc = { x: trip.startLocation.longitude, y: trip.startLocation.latitude }
        const endLoc = { x: trip.endLocation.longitude, y: trip.endLocation.latitude }
        const newRoute = this.directionsDAO.getRoute(tripID, startLoc, endLoc, wayPoints)
        trip.polyline = (await newRoute).polyline
        //Write to database
        await this.tripDAO.updateCreatedTrip(tripID, trip)

        // Charge the driver cancelation fee  and store it in drivers account balance
        const scheduleTime = new Date(trip.startTime.seconds * 1000).getTime()
        const currentTime = new Date().getTime()
        const calculatedTime = ((scheduleTime - currentTime) / 1000)
        //console.log(scheduleTime, "=====", currentTime,"====", calculatedTime)

        if ((calculatedTime < 10800) && (calculatedTime > 0)) {

            //Update the driver balance by applying a $5 penality
            const driver = await this.userDAO.getAccountData(driverID)
            if (driver.driverInfo?.accountBalance !== undefined) {
                driver.driverInfo.accountBalance -= 5
            }
        }

        const tokens = await this.notificationsDAO.getTokenList([riderID])

        const message = {
            subject: "Your trip had been canceled by the driver",
            driverID: driverID,
            tripID: tripID,
            notificationID: 1
        }

        sendCustomNotification(tokens, message)

    }

    async deleteRidebyDriver(driverID: string, tripID: string): Promise<void> {

        //Get trip from the database
        const trip = await this.tripDAO.getCreatedTrip(tripID)

        // Charge the driver cancelation fee  and store it in drivers account balance
        const scheduleTime = trip.startTime.toDate().getTime()
        const currentTime = new Date().getTime()
        const calculatedTime = ((scheduleTime - currentTime) / 1000)
        console.log(scheduleTime, "=====", currentTime, "====", calculatedTime)

        if ((calculatedTime < 10800) && (calculatedTime >= 0)) {

            //Update the driver balance by applying a $5 penality
            const driver = await this.userDAO.getAccountData(driverID)
            if (driver.driverInfo?.accountBalance !== undefined) {
                driver.driverInfo.accountBalance -= 5
                //console.log(driver.driverInfo)
                const data: Partial<UserSchema> = {
                    driverInfo: driver.driverInfo
                }
                await this.userDAO.updateAccountData(driverID, data)
            }
        }
        else if (calculatedTime < 0) {
            throw new Error('Trip is overdue.')
        }


        const tripIDs: string[] = []
        const snapshot = trip.riderInfo

        snapshot.forEach((element) => {
            tripIDs.push(element.riderID)
        })
        //tripIDs.push(driverID)

        //console.log(tripIDs)


        const tokens = await this.notificationsDAO.getTokenList(tripIDs)

        //console.log(tokens)
        const message = {
            subject: "Your trip had been canceled by the driver",
            driverID: driverID,
            tripID: tripID,
            notificationID: 1
        }

        sendCustomNotification(tokens, message)

        await this.tripDAO.deleteCreatedTrip(tripID)
    }


    async declineRiderRequest(driverID: string, riderID: string, tripID: string): Promise<void> {

        //Get trip from the database
        const trip = await this.tripDAO.getCreatedTrip(tripID)

        // Check if trip exist in the database
        if (trip.riderStatus[riderID] !== "Requested") {
            throw new HttpsError('invalid-argument', `Can't decline a rider hasn't requested to join`)
        }

        // Cancel the rider by changing his status to Rejected. 
        // This ride will not be shown in his search
        trip.riderStatus[riderID] = 'Rejected'

        // Delete rider-info from the database

        const arr = trip.riderInfo
        arr.slice().reverse().forEach((element, i) => {
            if (element.riderID === riderID) {
                arr.splice(i)
            }
        });

        trip.riderInfo = arr

        //Write to database
        await this.tripDAO.updateCreatedTrip(tripID, trip)

        const token = await this.notificationsDAO.getTokenList([riderID])

        //console.log(token)

        const message = {
            subject: "Your request to join a trip has been declined by the driver",
            driverID: driverID,
            tripID: tripID,
            notificationID: 1
        }

        sendCustomNotification(token, message)

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
        //change status to rejected and update seatAvailble
        trip.riderStatus[riderID] = 'Accepted'

        trip.seatsAvailable = trip.seatsAvailable - 1

        const start = { x: trip.startLocation.longitude, y: trip.startLocation.latitude } as Point
        const end = { x: trip.endLocation.longitude, y: trip.endLocation.latitude } as Point

        const wayPoints = this.getWaypoints(trip, 'Accepted')

        const updatedRoute = await this.directionsDAO.getRoute(tripID, start, end, wayPoints)

        trip.polyline = (await updatedRoute).polyline

        await this.tripDAO.updateCreatedTrip(tripID, trip)

        const token = await this.notificationsDAO.getTokenList([riderID])

        const message = {
            subject: "Your request to join a trip has been accepted by the driver",
            driverID: trip.driverID,
            tripID: tripID,
            notificationID: 1
        }

        sendCustomNotification(token, message)
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

    async riderRequestTrip(riderID: string, tripID: string, pickup: Point, dropoff: Point, startAddress: string, destinationAddress: string, passengers: number): Promise<void> {
        const trip = await this.tripDAO.getCreatedTrip(tripID)
        if (trip === undefined) {
            throw new HttpsError('not-found', 'Trip does not exist')
        }

        const start = { x: trip.startLocation.longitude, y: trip.startLocation.latitude } as Point
        const end = { x: trip.endLocation.longitude, y: trip.endLocation.latitude } as Point

        const wayPoints = this.getWaypoints(trip, 'Accepted')

        const meters = GeoDistance(pickup, dropoff)
        
        const newRiderInfo: TripRiderInfo = {
            dropoffAddress: destinationAddress,
            pickupAddress: startAddress,
            dropoffLocation: new firestore.GeoPoint(dropoff.y, dropoff.x),
            pickupLocation: new firestore.GeoPoint(pickup.y, pickup.x),
            estimatedFare: calculateFare(0, 0, meters / 1600, 1.50, 0.0),
            passengerCount: passengers,
            pickupIndex: 0,
            dropoffIndex: 0,
            riderID: riderID
        }

        wayPoints.push(pickup)
        wayPoints.push(dropoff)



        await this.directionsDAO.getRoute(tripID, start, end, wayPoints)


        const data: any = { riderInfo: firestore.FieldValue.arrayUnion(newRiderInfo) as any }
        data[`riderStatus.${riderID}`] = 'Requested'

        await this.tripDAO.updateCreatedTrip(tripID, data)

        const token = await this.notificationsDAO.getTokenList([trip.driverID])

        const message = {
            subject: "A rider is requesting to join your trip!",
            driverID: trip.driverID,
            tripID: tripID,
            notificationID: 1
        }

        sendCustomNotification(token, message)
    }



    async addRiderTripRating(tripID: string, riderID: string, rating: number): Promise<string> {

        const trip = await this.tripDAO.getSchedulededTrip(tripID)

        trip.ridersRateDriver[riderID] = rating

        await this.tripDAO.updateScheduledTrip(tripID, trip)

        return "Rating added Successfully!!"
    }

    async addDriverTripRating(tripID: string, riderID: string, rating: number): Promise<string> {

        const trip = await this.tripDAO.getSchedulededTrip(tripID)

        trip.driverRatesRiders[riderID] = rating

        await this.tripDAO.updateScheduledTrip(tripID, trip)

        return "Rating added Successfully!!"
    }



}