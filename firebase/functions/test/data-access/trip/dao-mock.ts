import { TripDAOInterface } from '../../../src/data-access/trip/dao'
import { CreatedTripSchema, GeoPointSchema, ScheduleTripSchema } from '../../../src/data-access/trip/schema';

export class TripDAOMock implements TripDAOInterface {

    tripsCreatedCollection: { id: string, data: CreatedTripSchema }[] = []

    calls: {
        updateCreatedTrip: { tripID: string, data: Partial<CreatedTripSchema> }[]
        getCreatedTrip: string[]
    }

    constructor() {
        this.calls = {
            updateCreatedTrip: [],
            getCreatedTrip: []
        }
    }

    createAddedTrip(id: string, data: CreatedTripSchema): Promise<string> {
        throw new Error('Method not implemented.');
    }
    getDriverTrips(driverID: string): Promise<CreatedTripSchema[]> {
        throw new Error('Method not implemented.');
    }
    getRiderTrips(riderID: string): Promise<CreatedTripSchema[]> {
        throw new Error('Method not implemented.');
    }
    addGeoPoints(points: GeoPointSchema[]): Promise<void> {
        throw new Error('Method not implemented.');
    }
    removeGeoPoints(tripID: string): Promise<GeoPointSchema[]> {
        throw new Error('Method not implemented.');
    }
    getGeoPointsByTripID(tripID: string): Promise<GeoPointSchema[]> {
        throw new Error('Method not implemented.');
    }
    getGeoPointsByHash(hash: string): Promise<GeoPointSchema[]> {
        throw new Error('Method not implemented.');
    }

    updateCreatedTrip(tripID: string, data: Partial<CreatedTripSchema>): Promise<void> {
        this.calls.updateCreatedTrip.push({ tripID: tripID, data: data })
        // this.tripsCreatedCollection.forEach((doc, i) => {
        //     if (doc.id === tripID) {
        //         this.tripsCreatedCollection[i].data.polyline = data.polyline
        //     }
        // })
        return Promise.resolve()
    }

    getCreatedTrip(tripID: string): Promise<CreatedTripSchema> {
        this.calls.getCreatedTrip.push(tripID)
        for (const doc of this.tripsCreatedCollection) {
            if (doc.id === tripID) {
                return Promise.resolve(doc.data)
            }
        }
        return Promise.reject(new Error(`Trip doesn't exist.`))
    }

    getDriverCompletedTrips(driverID: string): Promise<ScheduleTripSchema[]> {
        throw new Error('Method not implemented.');
    }
    getRiderCompletedTrips(riderID: string): Promise<ScheduleTripSchema[]> {
        throw new Error('Method not implemented.');
    }

}