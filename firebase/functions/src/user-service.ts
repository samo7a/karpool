import { DatabaseDAOInterface } from "./database-dao";
import { Address } from "./models/address";
import { User } from "./models/user";

export class UserService {

    private databaseDAO: DatabaseDAOInterface

    constructor(databaseDAO: DatabaseDAOInterface) {
        this.databaseDAO = databaseDAO
    }

    /**
     * @param userID
     * @param firstName 
     * @param lastName 
     * @param gender 
     * @param email 
     * @param dob 
     * @param address 
     * @param phone 
     * @param joinDate 
     */
    async registerRider(
        userID: string,
        firstName: string,
        lastName: string,
        gender: string,
        email: string,
        dob: Date,
        address: Address,
        phone: string,
        joinDate: Date
    ): Promise<void> {
        const user = new User(firstName, lastName, phone, email, gender, dob, address, joinDate, undefined, undefined)
        await this.databaseDAO.createUserInfo(userID, user)
            .catch(err => {
                if (err.code === 'already-exists') {

                } else {
                    return Promise.reject(err)
                }
            })
        this.databaseDAO.deleteDriverInfo('') //Placeholder so database warning goes away. Remove later.
        throw new Error('Unimplemented.')
    }


}