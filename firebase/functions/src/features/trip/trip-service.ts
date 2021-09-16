import { CreatedTripSchema} from "../../data-access/trip/schema";
import { TripCreationData } from "./types";
import { TripDAOInterface } from '../../data-access/trip/dao'
import { firestore } from "firebase-admin";
import { DirectionsDAOInterface } from "../../data-access/directions/dao";
import { HttpsError } from "firebase-functions/lib/providers/https";
import { Point } from "../../models-shared/route";


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


    /**
     * @param riderID
     * @returns scheduled trips
     */
    async getRiderTrips(riderID: string): Promise<CreatedTripSchema[]>{

        const riderTrips = await this.tripDAO.getRiderTrips(riderID)

        return riderTrips
    }


     /**
     * @param tripID
     */

    async cancelRide(riderID: string, tripID: string): Promise<void>{

    //Read from database

    //Do logic

    //Write to database
    
        await this.tripDAO.updateCreateTrip(tripID, (trip) => {
            if(trip.riderStatus[riderID] === undefined) {
                throw new HttpsError('aborted',`Rider isn't part of this ride.`)
            }
            trip.riderStatus[riderID] = 'Rejected'
           return trip 
        })


        // const trip2 = await this.tripDAO.getCreatedTrip(tripID)




        //         // Call change route function to update route
                
        //         const scheduleTime = trip2.startTime.getTime()
        //         const currentTime = new Date().getTime()
        
        // if (((currentTime - scheduleTime) /1000 ) < 10800 ){

                   // Charge the rider $5 penality or add a field in user as debt and add the value

          //  }
    }

    /*
     * 
     * @param pickup 
     * @param dropoff 
     * @param after 
     * @param before 
     * @returns 
     */
    searchTrips(pickup: Point, dropoff: Point, after: Date, before: Date): Promise<CreatedTripSchema[]> {
        return Promise.reject(new Error('Method Unimplemented.'))
    }



}