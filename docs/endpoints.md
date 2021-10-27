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

# Account Methods

## account-setBankAccount

### Request data

```typescript
{
    accountNum: string
    routingNum: string
}
```

### Returns

Empty response


## account-getUser

### Request data 

```typescript
{
    uid: string (id of the target account being requested)
    driver: boolean
}
```

### Returns 

```typescript 
{
    firstName: string
    lastName: string
    email?: string
    phone: string
    gender?: string
    joinDate?: Date
    driverRating?: number
    driverRatingCount?: number
    riderRating?: number
    riderRatingCount?: number
    profileURL?: string
    licenseNum?: string
    roles?: Record<string, boolean>
    bankAccount?: { (Exists only when requestData.driver == true)
        account: string
        routing: string
    }
}
```

## account-getVehicle

### `No Request data`

### Returns

```typescript
{
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
```

## account-updateVehicle

### Request Data

`NOTE: All fields in request data are optional so you can specify only the ones you want updated.`

```typescript
{
    color: string,
    insurance: {
        provider: string
        coverageType: string
        startDate: Date (ISO8601String)
        endDate: Date (ISO8601String)
    },
    licensePlateNum: string
    make: string
    year: string
}
```

### Returns 

Empty response



## account-deleteAccount

### `No Request Data`

### Returns empty response





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



## account-getEarnings

### `No Request Data`

### Returns: An array containing 2 arrays (Weeks and Months). The weeks array has objects shaped like

```typescript
[
    [
        {
            weekNum: number
            amount: number
        }
    ],
    [
        {
            month: number
            amount: number
        }
    ]
]
    
```




## account-editProfile

### Request Data

```typescript
{
    phoneNum: string
    pic: string (Base64Encoded)
    email: string
    
}
```

### Returns: Empty Response
