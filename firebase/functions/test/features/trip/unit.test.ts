import { newCreatedTrip, setup } from "./setup"


describe('Trip Service', () => {

    describe(`#cancelRidebyRider()`, () => {

        test(`Throws if rider doesn't exist in the trip.`, async () => {

            const expected = {
                tripID: 'tripID',
                riderID: 'DNE_ID'
            }

            const { tripService, tripDAO } = setup()

            const trip = newCreatedTrip()
            trip.riderInfo = []
            tripDAO.tripsCreatedCollection = [{ id: expected.tripID, data: trip }]

            await expect(tripService.cancelRidebyRider(expected.riderID, expected.tripID)).rejects.toThrow(`Rider isn't part of this ride.`)

        })

        test(`Throws if rider has already been rejected.`, async () => {

            const expected = {
                tripID: 'tripID',
                riderID: 'DNE_ID'
            }

            const { tripService, tripDAO } = setup()

            const trip = newCreatedTrip()
            trip.riderStatus[expected.riderID] = 'Rejected'
            tripDAO.tripsCreatedCollection = [{ id: expected.tripID, data: trip }]

            await expect(tripService.cancelRidebyRider(expected.riderID, expected.tripID)).rejects.toThrow(`Rider has already cancelled this ride.`)
        })

        test(`Updates trip document's fields correctly.`, async () => {

            throw new Error('Test not finished.')

            // //Setup 
            // const expected = {
            //     tripID: 'tripID',
            //     riderID: 'DNE_ID'
            // }

            // const { tripService, tripDAO } = setup()

            // const trip = newCreatedTrip()
            // trip.riderStatus[expected.riderID] = 'Rejected'
            // trip.seatsAvailable = 2
            // tripDAO.tripsCreatedCollection = [{ id: expected.tripID, data: trip }]

            // //Run action

            // await tripService.cancelRidebyRider(expected.riderID, expected.tripID)

            // //Test Results

            // expect(tripDAO.calls.updateCreatedTrip.length).toBe(1)

            // const fields = tripDAO.calls.updateCreatedTrip[0].data

            // expect(fields.polyline).toBe('TODO') //TODO: Return a default route from the mock that we can compare to.
            // expect(fields.seatsAvailable).toBe(-1) //TODO 
            // expect(fields.riderInfo!.filter(e => e.riderID === expected.riderID).length).toBe(0) //Check that riderInfo doesn't contain the cancelled rider.
            // expect(fields.isOpen).toBe(true)
            // expect(fields.riderStatus![expected.riderID]).toBe('Rejected')

        })


        test(`Requests a new route only once.`, async () => {

            throw new Error('Test not finished.')

            // const expected = {
            //     tripID: 'tripID',
            //     riderID: 'SomeRiderID'
            // }

            // const { tripService, routeDAO } = setup()

            // await tripService.cancelRidebyRider(expected.riderID, expected.tripID)

            // expect(routeDAO.calls.getRoute.length).toBe(1)

            //TODO: Check calls

        })

        test(`Charges rider if cancels after threshold time.`, () => {
            throw new Error('Test not finished.')
        })


    })

})