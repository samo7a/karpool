import { CreatedTripSchema } from "../../data-access/trip/schema";
import { TripCreationData } from "./types";
import { TripDAOInterface } from '../../data-access/trip/dao'
import { firestore } from "firebase-admin";


export class TripService {
    private tripDAO: TripDAOInterface



    constructor(
        tripDAO: TripDAOInterface,
        ) {
            this.tripDAO = tripDAO
    }

    /**
     * 
     * @param data Fields required to create a trip.
     * @returns The id of the trip document.
     */
    async createAddedTrip(uid: string, data: TripCreationData): Promise<string> {
        
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
       // return Promise.resolve('')
    }

    /**
     * 
     * @param driverID 
     * @returns 
     */
    getTrips(driverID: string): Promise<CreatedTripSchema[]> {
        return Promise.resolve([])

    }



}