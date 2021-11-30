

export interface TripCreationData {

    /**
     * Format: ISO8601 Zulu time - 2021-09-23T00:30:05.075Z
     */
    startTime: string

    startAddress: string

    startPlaceID: string

    endAddress: string

    endPlaceID: string

    seatsAvailable: number

}