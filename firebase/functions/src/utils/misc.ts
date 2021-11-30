import { Point } from "../models-shared/route";


/**
 * TODO: Make accurate.
 * Returns distance between 2 points in meters
 * @param p1 Point 1
 * @param p2 Point 2
 */
export function GeoDistance(p1: Point, p2: Point): number {
    const coordToMeterFactor = 111111.00
    return Math.sqrt(Math.pow(p2.x - p1.x, 2) + Math.pow(p2.y - p1.y, 2)) * coordToMeterFactor
}