
import { validateBool, validateString } from "../../utils/validation"
import { UserRegistrationData } from "./types";


/*
{
    firstName: string
    lastName: string
    gender: string
    email: string
    password: string
    dob: string (yyyy-mm-dd)
    phone: string
    profilePicData: string (base64Encoded)
    accountNum: string
    routingNum: string
    make: string
    color: string
    isDriver: true,
    year: 
}
*/


/**
 * Validates the 
 * @param data Data received from the client.
 * @returns Validated user registration information.
 */
export function validateRegistrationData(data: any): UserRegistrationData {

    const isDriver = validateBool(data.isDriver)

    if (isDriver) {
        return {
            firstName: validateString(data.firstName, 'First Name'),
            lastName: validateString(data.lastName, 'Last Name'),
            gender: validateString(data.gender, 'Gender'),
            email: validateString(data.email, 'Email'),
            uid: validateString(data.uid, 'UID'),
            dob: validateString(data.dob, 'Date of birth'),
            phone: validateString(data.phone, 'Phone'),
            profilePicData: validateString(data.profilePicData, 'Profile Picture Data'),
            accountNum: validateString(data.accountNum, 'Account Number'),
            routingNum: validateString(data.routingNum, 'Routing Number'),
            make: validateString(data.make, 'Make'),
            color: validateString(data.color, 'Color'),
            isDriver: true,
            year: validateString(data.year, 'Year'),
            plateNum: validateString(data.plateNum, 'Plate Num'),
            provider: validateString(data.provider, 'Provider'),
            coverage: validateString(data.coverage, 'Coverage'),
            startDate: validateString(data.startDate, 'Start Date'),
            endDate: validateString(data.endDate, 'End Date'),
            licenseNum: validateString(data.licenseNum, 'License Number')
        }
    } else {
        return {
<<<<<<< HEAD
            firstName: validateString(data.firstName, 'First Name'),
            lastName: validateString(data.lastName, 'Last Name'),
            gender: validateString(data.gender, 'Gender'),
            email: validateString(data.email, 'Email'),
            uid: validateString(data.uid, 'UID'),
            dob: validateString(data.dob, 'Date of birth'),
            phone: validateString(data.phone, 'Phone'),
            profilePicData: validateString(data.profilePicData, 'Profile Picture Data'),
=======
            firstName: validateString(data.firstName),
            lastName: validateString(data.lastName),
            gender: validateString(data.gender),
            email: validateString(data.email),
            password: validateString(data.password),
            dob: validateString(data.dob),
            phone: validateString(data.phone),
            profilePicData: validateString(data.profilePicData),
>>>>>>> trips
            isDriver: false
        }
    }
}


