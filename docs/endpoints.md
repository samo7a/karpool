
# Trip Methods




## trip-searchTrips

### Request Data
```
{
   pickupLocation: {
       x: number
       y: number
   }
   dropoffLocation: {
       x: number
       y: number
   }
   passengerCount: number
   startDate: string 
}
```

### Returns
```
[
    {
        docID: string
        driverID: string
        startTime: firestore.Timestamp
        startLocation: string
        endLocation: string
        riderStatus: Record<string, string>
        isOpen: boolean
        estimatedDistance: number
        estimatedTotalFare: number
        estimatedDuration: number
        seatsAvailable: number
        polyline: string
    }
]
```
