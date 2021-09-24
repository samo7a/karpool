import { Point } from '../models-shared/route'
import * as geohash from 'ngeohash'
import { GeoPointSchema } from '../data-access/trip/schema'

//TODO: Unit test all methods in this file.

/** 
 * Sorts the points by 'x' from smallest to largest. Then by 'y' from smallest to largest.
 * The sorted list is then encoded to a list of geo-hashes which are joined together.
 * NOTE: The hashes are encoded at a precision of 7 so its extremely unlikely that two routes will have the same cacheID.
 * @param points A list of points.
 */
export function cacheID(points: Point[]): string {
    const sorted = points.sort((a, b) => {
        const dx = a.x - b.x
        return dx === 0 ? a.y - b.y : dx
    })
    return sorted.map(p => geohash.encode(p.y, p.x, 7)).join('')
}


/**
 * 
 * @param waitTime 
 * @param drivingTime 
 * @param mileage 
 * @param baseFare 
 * @param tolls 
 * @returns 
 */
export function calculateFare(waitTime: number, drivingTime: number, mileage: number, baseFare: number, tolls: number): number {
    return waitTime * 0.03 + drivingTime * 0.015 + mileage * 0.4 + baseFare + tolls
}



//Assume points are in order.
export function hashesForPoints(tripID: string, points: Point[], geoPrecision: number): GeoPointSchema[] {

    const allPoints: Point[] = points.map(p => Object.assign({}, p))

    const set = new Set<string>()

    const trimmed: GeoPointSchema[] = []

    //Add center points to hash list first
    points.forEach((p, i) => {
        const hash = geohash.encode(p.y, p.x, geoPrecision)
        if (!set.has(hash)) {
            set.add(hash)
            trimmed.push({
                x: p.x,
                y: p.y,
                hash: hash,
                index: i,
                tripID: tripID
            })
        }
    })

    //Add cross points if they find any not discovered geohash squares.
    //Each cross point that is added to the final list should have the same index as its origin point.
    points.forEach((p, i) => {
        crossPoints(p, 3200).forEach(crossPoint => {
            const hash = geohash.encode(crossPoint.y, crossPoint.x, geoPrecision)
            if (!set.has(hash)) {
                set.add(hash)
                trimmed.push({
                    x: crossPoint.x,
                    y: crossPoint.y,
                    hash: hash,
                    index: i,
                    tripID: tripID
                })
            }
            allPoints.push(crossPoint)
        })
    })

    return trimmed

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

    points.push({ x: point.x + coordinateDistance, y: point.y }) //East (For simplicity, we'll assume all longitudes are spaced evenly apart at all latitudes)
    points.push({ x: point.x - coordinateDistance, y: point.y }) //West TODO: (For simplicity, we'll assume all longitudes are spaced evenly apart at all latitudes)

    return points
}

/*


Start and end match with route

Start and end matches is reversed

Start passes through but not end

End passes through but not start



*/