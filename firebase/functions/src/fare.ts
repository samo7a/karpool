
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