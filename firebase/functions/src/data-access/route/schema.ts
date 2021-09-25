

interface Point {

    /**
     * Longitude
     */
    x: number

    /**
     * Latitude
     */
    y: number
}



export interface RouteSchema {

    tripID: string //For queries

    waypointOrder: number[]

    polyline: string

    legs: RouteLegSchema[]

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

export interface RouteLegSchema {

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


    steps: RouteStepSchema[]
}


export interface RouteStepSchema {

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