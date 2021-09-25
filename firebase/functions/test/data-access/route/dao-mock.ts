import { RouteDAOInterface } from '../../../src/data-access/route/dao'
import { Point, Route } from '../../../src/models-shared/route';
import { routeDummy } from './dummy'

//TODO: Move to test folder working on unit tests.
export class RouteDAOMock implements RouteDAOInterface {

    calls: {
        getCoordinates: string[]
        getRoute: { tripID: string, start: Point, end: Point, waypoints: Point[] }[]
    }

    constructor() {
        this.calls = {
            getCoordinates: [],
            getRoute: []
        }
    }


    getCoordinates(placeID: string): Promise<Point> {
        this.calls.getCoordinates.push(placeID)
        return Promise.resolve({ x: 0, y: 0 })
    }



    getRoute(tripID: string, start: Point, end: Point, waypoints: Point[]): Promise<Route> {
        this.calls.getRoute.push({ tripID: tripID, start: start, end: end, waypoints: waypoints })
        const dummy = routeDummy()
        return Promise.resolve(
            new Route(dummy.waypointOrder, dummy.polyline, dummy.legs, dummy.distance, dummy.duration)
        )
    }
}
