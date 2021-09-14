
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


export interface Route {

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