import { DatabaseDAOInterface } from "./database-dao";
import { ReviewResult, TripResult } from "./models/review";



export class RiderService {

    private databaseDAO: DatabaseDAOInterface

    constructor(databaseDAO: DatabaseDAOInterface) {
        this.databaseDAO = databaseDAO
    }

    /**
     * 
     * @param firstName 
     * @param lastName 
     * @param gender 
     * @param email 
     * @param dob 
     * @param address 
     * @param phone 
     * @param joinDate 
     */
    registerRider(
        firstName: string,
        lastName: string,
        gender: string,
        email: string,
        dob: Date,
        address: string,
        phone: string,
        joinDate: Date
    ): Promise<void> {
        this.databaseDAO.deleteDriver('') //Placeholder so database warning goes away. Remove later.
        throw new Error('Unimplemented.')
    }

    /**
     * 
     * @param encryptedData 
     */
    setupPaymentMethod(encryptedData: string): Promise<void> {
        throw new Error('Unimplemented.')
    }

    /**
     * 
     * @param driverID 
     * @param rating 
     * @param review 
     */
    writeReview(
        driverID: string,
        rating: number,
        review: string
    ): Promise<void> {
        throw new Error('Unimplemented.')
    }

    /**
     * 
     * @param riderID 
     * @param limit 
     */
    getReviews(
        riderID: string,
        limit?: string
    ): Promise<ReviewResult[]> {
        throw new Error('Unimplemented.')
    }

    /**
     * 
     * @param startDate 
     * @param endDate 
     * @param limit 
     */
    getTripHistory(
        startDate: Date,
        endDate: Date,
        limit?: number
    ): Promise<TripResult[]> {
        throw new Error('Unimplemented.')
    }

    /**
     * 
     * @param tripID 
     * @param riderID 
     */
    bookTrip(
        tripID: string,
        riderID: string
    ): Promise<string> {
        throw new Error('Unimplemented.')
    }

    /**
     * 
     * @param driverID 
     */
    getDriverProfile(
        driverID: string
    ): Promise<void> {
        throw new Error('Unimplemented.')
    }


}