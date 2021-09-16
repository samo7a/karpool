import { Point } from './models-shared/route'
// import * as geohash from 'ngeohash'


export function hashesForPoints(tripID: string, points: Point[], geoPrecision: number) {

    const allPoints: Point[] = points.map(p => Object.assign({}, p))



    points.forEach(p => {

        allPoints.push(Object.assign({}, p))

        crossPoints(p, 1600).forEach(crossPoint => {
            allPoints.push(crossPoint)
        })
    })

}

/**
 * Creates 4 points 
 * @param point A point as longitude and latitude.
 * @param distance The distance each cross point should be from the given point. (Meters)
 */
function crossPoints(point: Point, distance: number): Point[] {

    const coordinateDistance = distance / 111111.00

    const points: Point[] = []
    points.push({ x: point.x, y: point.y + coordinateDistance }) //North
    points.push({ x: point.x, y: point.y - coordinateDistance }) //Sourth

    points.push({ x: point.x + coordinateDistance, y: point.y }) //East TODO: Need to calculate since the distance between longitudes change based on the latitude.
    points.push({ x: point.x - coordinateDistance, y: point.y }) //West TODO: Need to calculate since the distance between longitudes change based on the latitude.


    return points
}