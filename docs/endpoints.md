  

# Trip Methods

  

  
## trip-getStartEndCoordinates

### Request Data

```typescript
{
    startPlaceID: string
    endPlaceID: string
}
```

### Returns

```typescript
{
    startLocation: { longitude: number, latitude: number }
    endLocation: { longitude: number, latitude: number }
}
```  

  

## trip-searchTrips

  

### Request Data

```typescript
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
