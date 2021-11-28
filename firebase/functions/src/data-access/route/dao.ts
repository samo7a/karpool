// import * as ngeo from 'ngeohash'
import { Client, DirectionsRoute, DirectionsStep, LatLng, RouteLeg } from '@googlemaps/google-maps-services-js'
import { firestore } from 'firebase-admin';
import { FirestoreKey } from '../../constants';
import { Point, Route, Leg, Step } from "../../models-shared/route";
import { cacheID as cacheIDMethod } from '../../utils/route';
import { RouteSchema } from './schema';


export interface RouteDAOInterface {

    /**
     * Creates a route between the start and end points which passes through all waypoints.
     * @param start A point or address string that specifies where the route will start.
     * @param end A point or address string that specifies where the route will end.
     * @param waypoints An array of points or address strings the route must pass through.
     */
    getRoute(tripID: string, start: Point, end: Point, waypoints: Point[], departureTime?: Date): Promise<Route>


    getCoordinates(placeID: string): Promise<Point>

}

//GOOGLEDAO
export class RouteDAO implements RouteDAOInterface {

    private apiKey: string

    private db: firestore.Firestore

    constructor(
        database: firestore.Firestore,
        apiKey: string
    ) {
        this.apiKey = apiKey
        this.db = database
    }


    getCoordinates(placeID: string): Promise<Point> {
        return new Client({}).placeDetails({
            params: {
                key: this.apiKey,
                place_id: placeID,
                fields: ['geometry']
            }
        }).then(res => {
            const coords = res.data.result.geometry?.location
            if (coords === undefined) {
                throw new Error(`No coordinates for ${placeID}.`)
            } else {
                return { y: coords.lat, x: coords.lng }
            }
        })
    }


    /**
     * Stores the route data so it can be retrieved later without needing to call the Google API.
     * @param tripID The document id of the trip the given route is associated with.
     * @param cacheID An id generated derived from start, end, and waypoints points the route passes through.
     * @param route A route object.
     */
    private async cacheRoute(tripID: string, cacheID: string, route: Route): Promise<void> {
        const data: RouteSchema = {
            waypointOrder: route.waypointOrder,
            tripID: tripID,
            legs: route.legs,
            distance: route.distance,
            duration: route.duration,
            polyline: route.polyline
        }
        await this.db.collection(FirestoreKey.cachedRoutes).doc(cacheID).create(data)
    }



    private getCachedRoute(points: Point[]): Promise<Route | undefined> {

        const routeHash = cacheIDMethod(points)

        return this.db.collection(FirestoreKey.cachedRoutes).doc(routeHash).get().then(doc => {
            if (doc.exists) {
                const rawRoute = doc.data() as RouteSchema
                return new Route(
                    rawRoute.waypointOrder,
                    rawRoute.polyline,
                    rawRoute.legs,
                    rawRoute.distance, rawRoute.duration
                )
            } else {
                return undefined
            }
        })
    }




    async getRoute(tripID: string, start: Point, end: Point, waypoints: Point[], departureTime?: Date): Promise<Route> {


        const points: Point[] = [start, end]
        waypoints.forEach(p => {
            points.push(p)
        })
        const cachedRoute = await this.getCachedRoute(points)

        if (cachedRoute !== undefined) {
            console.log('Found route in the cache!')
            return cachedRoute
        }

        const origin: LatLng = typeof start === 'string' ? start : [start.y, start.x]

        const destination: LatLng = typeof end === 'string' ? end : [end.y, end.x]

        const formattedWaypoints: LatLng[] = waypoints.length === 0 ? [] : waypoints.map(p => typeof p === 'string' ? p : [p.y, p.x])

        //The googleSDK crashes if the optimize is set to true and waypoints is undefined.
        //Passing an empty for waypoints results in whacky route to Texas problem.
        const shouldOptimize: boolean = formattedWaypoints !== undefined && formattedWaypoints.length > 0

        console.log(origin, destination, formattedWaypoints, shouldOptimize, 'CALL')

        return new Client({}).directions({
            params: {
                key: this.apiKey,
                departure_time: departureTime,
                optimize: shouldOptimize, //Want the most effecient route even if way points ordering is changed.
                alternatives: false, //Guaruntee only one route in response and increase performance.
                origin: origin,
                destination: destination,
                waypoints: formattedWaypoints
            }
        }).then(async res => {
            if (res.data.routes.length === 0) {
                return Promise.reject(`No routes found.`)
            } else {
                const newRoute = this.transformRoute(res.data.routes[0])
                console.log(`Didn't find route in cache. Getting from Google!`)
                await this.cacheRoute(tripID, cacheIDMethod(points), newRoute)
                return newRoute
            }
        })
    }

    private transformRoute(route: DirectionsRoute): Route {

        const legs = route.legs.map(leg => this.transformLeg(leg))

        return new Route(
            route.waypoint_order,
            route.overview_polyline.points,
            legs,
            this.getTotalDistance(legs),
            this.getTotalDuration(legs)
        )
    }


    private transformLeg(leg: RouteLeg): Leg {
        return {
            distance: leg.distance.value,
            duration: leg.duration.value,
            startPoint: { x: leg.start_location.lng, y: leg.start_location.lat },
            endPoint: { x: leg.end_location.lng, y: leg.end_location.lat },
            steps: leg.steps.map(step => this.transformStep(step))
        }
    }

    private transformStep(step: DirectionsStep): Step {
        return {
            distance: step.distance.value,
            duration: step.duration.value,
            startPoint: { x: step.start_location.lng, y: step.start_location.lat },
            endPoint: { x: step.end_location.lng, y: step.end_location.lat },
            instruction: step.html_instructions
        }
    }

    private getTotalDistance(legs: Leg[]): number {
        return legs.map(l => l.distance).reduce((sum, distance) => sum + distance)
    }

    private getTotalDuration(legs: Leg[]): number {
        return legs.map(l => l.duration).reduce((sum, distance) => sum + distance)
    }

}