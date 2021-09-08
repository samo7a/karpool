import { CreatedTripSchema } from "../../data-access/trip/schema";
import { TripCreationData } from "./types";


export class TripService {


    constructor() {

    }

    /**
     * 
     * @param data Fields required to create a trip.
     * @returns The id of the trip document.
     */
    createAddedTrip(data: TripCreationData): Promise<string> {


        return Promise.resolve('')
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