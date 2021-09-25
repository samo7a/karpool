import { validateNumber, validateString } from "../../utils/validation";
import { TripCreationData } from "./types";


export function validateAddTripData(data: any): TripCreationData {

    return {

        startTime: validateString(data.startTime, "1"),

        startAddress: validateString(data.startAddress, "2"),

        endAddress: validateString(data.endAddress, "3"),

        seatsAvailable: validateNumber(data.seatsAvailable),

        endPlaceID: validateString(data.endPlaceID),

        startPlaceID: validateString(data.startPlaceID)

    }
}