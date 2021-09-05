
import { validateBool, validateDate, validateNumber, validateString } from "../../utils/validation"
import { UserRegistrationData } from "./types";



/**
 * Validates the 
 * @param data Data received from the client.
 * @returns Validated user registration information.
 */
export function validateRegistrationData(data: any): UserRegistrationData {

    const isDriver = validateBool(data.isDriver)

    if (isDriver) {
        return {
            firstName: validateString(data.firstName),
            lastName: validateString(data.lastName),
            gender: validateString(data.gender),
            email: validateString(data.email),
            password: validateString(data.password),
            dob: validateString(data.dob),
            phone: validateString(data.phone),
            profilePicData: validateString(data.profilePicData),
            accountNum: validateString(data.accountNum),
            routingNum: validateString(data.routingNum),
            make: validateString(data.make),
            color: validateString(data.color),
            isDriver: true,
            year: validateString(data.year),
            plateNum: validateString(data.plateNum),
            provider: validateString(data.provider),
            coverage: validateString(data.coverage),
            startDate: validateDate(data.startDate),
            endDate: validateDate(data.endDate),
            licenseNum: validateString(data.licenseNum)
        }
    } else {
        return {
            firstName: validateString(data.firstName),
            lastName: validateString(data.lastName),
            gender: validateString(data.gender),
            email: validateString(data.email),
            password: validateString(data.password),
            dob: validateString(data.dob),
            phone: validateString(data.phone),
            profilePicData: validateString(data.profilePicData),
            cardNum: validateNumber(data.cardNum),
            cardExpDate: validateString(data.cardExpDate),
            cardCVC: validateNumber(data.cardCVC),
            isDriver: false,
            stripeToken: validateString(data.stripeToken)
        }
    }
}


