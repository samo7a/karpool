

import { AuthenticationDAOInterface } from "../../auth/dao";
import { UserDAOInterface } from '../../database/user/dao'
import { DriverRegistrationInfo, RiderRegistrationInfo, UserFieldsExternal } from './types'
import { Role } from "../../database/user/types";
import { UserSchema } from "../../database/user/schema";

export class AccountService {

    private userDAO: UserDAOInterface

    private authDAO: AuthenticationDAOInterface

    constructor(
        userDAO: UserDAOInterface,
        authDAO: AuthenticationDAOInterface
    ) {
        this.userDAO = userDAO
        this.authDAO = authDAO
    }

    /**
     * Registers a user as a rider. If the user has not already made a driver account, this will create 
     * their account data, otherwise it will just add the rider specified account info and won't override their existing account info (firstName etc.).
     * @param info Fields required for registering the user as a driver.
     */
    async registerRider(info: RiderRegistrationInfo): Promise<void> {

        await this.authDAO.registerAccount(info.email, info.password).then(userID => {
            return this.userDAO.createAccountData(userID, {
                firstName: info.firstName,
                lastName: info.lastName,
                phone: info.phone,
                email: info.email,
                gender: info.gender,
                dob: info.dob,
                driverInfo: undefined,
                riderInfo: {
                    rating: 0,
                    ratingCount: 0
                }
            })
        }).catch(async err => {
            if (err.code === 'already-exists') {
                const userID = await this.authDAO.getUserID(info.email)

                const userData: Partial<UserSchema> = {
                    riderInfo: {
                        rating: 0,
                        ratingCount: 0
                    }
                }
                const partialKey: Role = 'Rider' //Update roles dictionary. Since roles is a nested dictionary, to set a single key without overwriting the others, we have to use dot notation. We also have to case the userData as any to insert the special key.
                const copy = (userData as any)
                copy[`roles.${partialKey}`] = true

                return this.userDAO.updateAccountData(userID, userData)
            } else {
                return Promise.reject(err)
            }
        })
    }


    /**
     * Returns the publicly available information for a 
     * @param uid 
     * @returns 
     */
    getRiderProfile(uid: string, includePrivate: boolean): Promise<UserFieldsExternal> {
        return this.userDAO.getAccountData(uid).then(user => {
            return {
                firstName: user.firstName,
                lastName: user.lastName,
                phone: user.phone,
                gender: user.gender,
                joinDate: user.joinDate,
                driverRating: undefined,
                driverRatingCount: undefined,
                riderRating: user.driverInfo?.rating,
                riderRatingCount: user.driverInfo?.ratingCount,
                profileURL: user.profileURL,
                licenseNum: undefined
            }
        })
    }


    /**
     * 
     * @param fields 
     * @returns 
     */
    async updateRiderProfile(uid: string, fields: Partial<UserSchema>): Promise<void> {
        await this.userDAO.updateAccountData(uid, {
            firstName: fields.firstName,
            lastName: fields.lastName,
            phone: fields.phone
        })
    }

    /**
     * 
     * @param uid 
     * @returns 
     */
    deleteRiderProfile(uid: string): Promise<void> {
        /**
         * TODO:
         * If account is only registered as a rider, delete the entire account.
         * If the account is registered as a driver as well, only delete the rider specific account content.
         * Delete reviews of the rider.
         * Delete reviews authored by the rider.
         * Delete payment info if not stored in user document.
         */
        return Promise.reject(new Error('Unimplemented.'))
    }


    /**
    * 
    * @param info Fields required for registering the user as a driver.
    */
    async registerDriver(info: DriverRegistrationInfo): Promise<void> {
        return Promise.reject(new Error('Unimplemented.'))
    }


    /**
     * 
     * @param uid 
     * @returns 
     */
    getDriverProfile(uid: string, includePrivate: boolean): Promise<UserFieldsExternal> {
        return Promise.reject(new Error('Unimplemented.'))
    }


    /**
     * 
     * @param fields 
     * @returns 
     */
    async updateDriverProfile(uid: string, fields: Partial<UserSchema>): Promise<void> {
        return Promise.reject(new Error('Unimplemented.'))
    }

    /**
     * 
     * @param uid 
     * @returns 
     */
    deleteDriverProfile(uid: string): Promise<void> {
        return Promise.reject(new Error('Unimplemented.'))
    }



}