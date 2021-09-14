import { CreatedTripSchema } from "../../data-access/trip/schema";
import { TripCreationData } from "./types";
import { TripDAOInterface } from '../../data-access/trip/dao'
import { firestore } from "firebase-admin";
import { DirectionsDAOInterface } from "../../data-access/directions/dao";


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

        //TODO: Call the directionsDAO and store the route in the database.
        console.log(this.directionsDAO === undefined)

        return this.tripDAO.createAddedTrip({
            driverID: uid,

            startTime: firestore.Timestamp.fromDate(new Date(data.startTime)),

            startLocation: data.startAddress,

            riderStatus: {},

            isOpen: true,

            estimatedDistance: -1, //ToDO

            estimatedFare: 10, //ToDO

            seatCount: data.seatCount

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



}