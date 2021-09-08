import { CreatedTripSchema } from "./schema";


export interface TripDAOInterface {


    /**
     * 
     * @param data 
     * @returns The id of the trip document.
     */
    createAddedTrip(data: CreatedTripSchema): Promise<string>

    getTrips(driverID: string): Promise<CreatedTripSchema[]>



}

export class TripDAO implements TripDAOInterface {

    createAddedTrip(data: CreatedTripSchema): Promise<string> {
        throw new Error("Method not implemented.");
    }

    getTrips(driverID: string): Promise<CreatedTripSchema[]> {
        throw new Error("Method not implemented.");
    }

}