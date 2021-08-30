
import { validateString } from "../../utils/validation"
import { RiderRegistrationInfo } from "./types"

/** TODO: Implement actual validation
 * 
 * @param data 
 * @returns 
 */
export function validateRegistrationData(data: any): RiderRegistrationInfo {
    return {
        firstName: 'Some firstname',
        lastName: 'Some lastname',
        gender: 'Some gender',
        email: validateString(data.email, 'Email'),
        password: 'Some password',
        dob: new Date(),
        phone: '4071234567' //Use regex for formatting?
    }
}