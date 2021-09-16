import { Point } from './models-shared/route'
import * as geohash from 'ngeohash'
import { GeoPointSchema } from './data-access/trip/schema'


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
        crossPoints(p, 1600).forEach(crossPoint => {
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