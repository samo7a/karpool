// import * as ngeo from 'ngeohash'
import { Client, DirectionsRoute, DirectionsStep, LatLng, RouteLeg } from '@googlemaps/google-maps-services-js'
import { Point, Route, Leg, Step } from "../../models-shared/route";

export interface RouteDAOInterface {

    /**
     * Creates a route between the start and end points which passes through all waypoints.
     * @param start A point or address string that specifies where the route will start.
     * @param end A point or address string that specifies where the route will end.
     * @param waypoints An array of points or address strings the route must pass through.
     */
    getRoute(start: Point | string, end: Point | string, waypoints?: (Point | string)[], departureTime?: Date): Promise<Route>

}


export class RouteDAO implements RouteDAOInterface {

    private apiKey: string

    constructor(apiKey: string) {
        this.apiKey = apiKey
    }

    getRoute(start: Point | string, end: Point | string, waypoints?: (Point | string)[], departureTime?: Date): Promise<Route> {

        const origin: LatLng = typeof start === 'string' ? start : [start.y, start.x]

        const destination: LatLng = typeof end === 'string' ? end : [end.y, end.x]

        const formattedWaypoints: LatLng[] | undefined = waypoints === undefined ? undefined : waypoints.map(p => typeof p === 'string' ? p : [p.y, p.x])

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
        }).then(res => {
            if (res.data.routes.length === 0) {
                return Promise.reject(`No routes found.`)
            } else {
                return this.transformRoute(res.data.routes[0])
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