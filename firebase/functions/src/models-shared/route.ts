import * as polylineDecoder from 'google-polyline'


//Internal types that represent a route.

export interface Point {

    /**
     * Longitude
     */
    x: number

    /**
     * Latitude
     */
    y: number
}


export class Route {

    waypointOrder: number[]

    polyline: string

    legs: Leg[]

    /**
     * Distance to travel the entire trip.
     * (Meters)
     */
    distance: number

    /**
     * Duration to travel the entire trip.
     * (Seconds)
     */
    duration: number

    constructor(
        waypointOrder: number[],
        polyline: string,
        legs: Leg[],
        distance: number,
        duration: number
    ) {
        this.waypointOrder = waypointOrder
        this.polyline = polyline
        this.legs = legs
        this.distance = distance
        this.duration = duration
    }

    getPolylinePoints(): Point[] {
        return polylineDecoder.decode(this.polyline).map(p => ({ y: p[0], x: p[1] })) //Decoder orders coordiantes as [Lat, Long] (y, x)
    }

}

export interface Leg {

    /**
     * Distance to travel the leg.
     * (Meters)
     */
    distance: number

    /**
     * Duration to travel the leg.
     * (Seconds)
     */
    duration: number


    startPoint: Point


    endPoint: Point


    steps: Step[]
}


export interface Step {

    /**
     * Distance to travel the leg.
     * (Meters)
     */
    distance: number

    /**
     * Duration to travel the leg.
     * (Seconds)
     */
    duration: number


    startPoint: Point


    endPoint: Point


    instruction: string

}