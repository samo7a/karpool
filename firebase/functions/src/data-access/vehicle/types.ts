

export interface VehicleSchema {
    color: string
    insurance: {
        provider: string
        coverageType: string
        startDate: Date
        endDate: Date
    }
    licensePlateNum: string
    make: string
    year: string
    uid: string
}