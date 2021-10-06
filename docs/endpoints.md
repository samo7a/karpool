  

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


## trip-riderRequestTrip


### Request Data

```typescript
{   
    riderID: string

    tripID: string 

    pickup: Point 

    dropoff: Point

    passengerCount: number

    startAddress: string

    destinationAddress: string

    passengers: number

}
```
### Returns

```typescript
[

    Promise<void>

]
```

# User Methods

## account-getCreditCards

### `No Request Data`

### Returns (ARRAY)

```typescript
{

    brand: string

    cardHolder: string

    last4: string

    expMonth: string

    expYear: string

    id: string

    isDefault: boolean

    userID: string

}[]
```  


## account-deleteCreditCard

### Request Data

```typescript
{
    cardID: string
}
```

### Returns: Empty Response



## account-addCreditCard

### Request Data

```typescript
{
    cardToken: string
}
```

### Returns: Empty Response
