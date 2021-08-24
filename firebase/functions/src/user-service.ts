import { AuthenticationDAOInterface } from "./auth-dao";
import { DatabaseDAOInterface } from "./database-dao";
import { DriverRegistrationInfo, RiderRegistrationInfo } from "./models/register";
import { DriverInfo, RiderInfo, User } from "./models/user";

/**
 * A service class for performing user-related business logic.
 */
export class UserService {

    private databaseDAO: DatabaseDAOInterface

    private authDAO: AuthenticationDAOInterface

    constructor(
        databaseDAO: DatabaseDAOInterface,
        authDAO: AuthenticationDAOInterface
    ) {
        this.databaseDAO = databaseDAO
        this.authDAO = authDAO
    }


    /**
     * Registers a user as a rider. If the user has not already made a driver account, this will create 
     * their account data, otherwise it will just add the rider specified account info and won't override their existing account info (firstName etc.).
     * @param info Fields required for registering the user as a driver.
     */
    async registerRider(info: RiderRegistrationInfo): Promise<void> {
        const riderInfo: RiderInfo = {
            isRider: true,
            rating: 0,
            ratingCount: 0
        }

        await this.authDAO.registerAccount(info.email, info.password).then(userID => {
            const user = new User(info.firstName, info.lastName, info.phone, info.email, info.gender, info.dob, info.address, info.joinDate, undefined, riderInfo)
            return this.databaseDAO.createUserInfo(userID, user)
        }).catch(async err => {
            if (err.code === 'already-exists') {
                const userID = await this.authDAO.getUserID(info.email)
                return this.databaseDAO.updateUserInfo(userID, { riderInfo: riderInfo })
            } else {
                return Promise.reject(err)
            }
        })
    }

    /**
     * Registers a user as a driver. If the user has not already made a rider account, this will create 
     * their account data, otherwise it will just add the driver specified account info and won't override their existing account info (firstName etc.).
     * @param info Fields required for registering the user as a rider.
     */
    async registerDriver(info: DriverRegistrationInfo): Promise<void> {
        const driverInfo: DriverInfo = {
            isDriver: true,
            licenseNum: info.licenseNum,
            rating: 0,
            ratingCount: 0
        }

        await this.authDAO.registerAccount(info.email, info.password).then(userID => {
            const user = new User(info.firstName, info.lastName, info.phone, info.email, info.gender, info.dob, info.address, info.joinDate, driverInfo, undefined)
            return this.databaseDAO.createUserInfo(userID, user)
        }).catch(async err => {
            if (err.code === 'already-exists') {
                const userID = await this.authDAO.getUserID(info.email)
                return this.databaseDAO.updateUserInfo(userID, { driverInfo: driverInfo })
            } else {
                return Promise.reject(err)
            }
        })

    }
}