
import { firestore } from "firebase-admin"
import { CreatedTripSchema } from "../../../src/data-access/trip/schema"
import { TripService } from "../../../src/features/trip/trip-service"
import { RouteDAOMock } from "../../data-access/route/dao-mock"
import { TripDAOMock } from "../../data-access/trip/dao-mock"
import { UserDAOMock } from "../../data-access/user/dao-mock"


export const setup = () => {
    const userDAO = new UserDAOMock()
    const tripDAO = new TripDAOMock()

    tripDAO.tripsCreatedCollection = [{ id: 'tripID', data: newCreatedTrip() }]

    const routeDAO = new RouteDAOMock()

    return {
        userDAO: userDAO,
        tripDAO: tripDAO,
        routeDAO: routeDAO,
        tripService: new TripService(userDAO, tripDAO, routeDAO)
    }
}


export const newCreatedTrip = (): CreatedTripSchema => {
    return {
        docID: '',
        driverID: '',
        startTime: new firestore.Timestamp(0, 0),
        startLocation: new firestore.GeoPoint(0, 0),
        endLocation: new firestore.GeoPoint(0, 0),
        startAddress: '',
        endAddress: '',
        riderStatus: {},
        riderInfo: [],
        isOpen: true,
        estimatedDistance: 0,
        estimatedTotalFare: 0,
        estimatedDuration: 0,
        seatsAvailable: 1,
        polyline: ''
    }
}