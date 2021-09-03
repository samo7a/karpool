

import { AuthenticationDAOInterface } from "../../auth/dao";
import { UserDAOInterface } from '../../data-access/user/dao'
import { UserFieldsExternal, UserRegistrationData } from './types'
import { UserSchema } from "../../data-access/user/schema";
import { CloudStorageDAOInterface } from "../../data-access/cloud-storage/dao";

export class AccountService {

    private userDAO: UserDAOInterface

    private authDAO: AuthenticationDAOInterface

    private cloudStorageDAO: CloudStorageDAOInterface

    constructor(
        userDAO: UserDAOInterface,
        authDAO: AuthenticationDAOInterface,
        storageDAO: CloudStorageDAOInterface
    ) {
        this.userDAO = userDAO
        this.authDAO = authDAO
        this.cloudStorageDAO = storageDAO
    }


    async registerUser(data: UserRegistrationData): Promise<void> {
        await this.authDAO.registerAccount(data.email, data.password).then(async uid => {

            const { downloadURL } = await this.cloudStorageDAO.writeFile('profile-pictures', uid, 'jpg', true)

            await this.userDAO.createAccountData(uid, {
                firstName: data.firstName,
                lastName: data.lastName,
                phone: data.phone,
                email: data.email,
                gender: data.gender,
                dob: data.dob,
                joinDate: new Date(),
                roles: { 'Rider': true },
                driverInfo: data.isDriver ? { licenseNum: data.licenseNum!, rating: 0, ratingCount: 0 } : undefined,
                riderInfo: data.isDriver ? undefined : { rating: 0, ratingCount: 0, stripeToken: data.stripeToken! },
                profileURL: downloadURL,
                bankAccount: {
                    accountNum: data.accountNum!,
                    routingNum: data.routingNum!
                }

            })

        }).catch(err => {
            console.log(err.message)
        })
    }


    /**
     * Returns the publicly available information for a 
     * @param uid 
     * @returns 
     */
    getRiderProfile(uid: string, includePrivate: boolean): Promise<UserFieldsExternal> {
        return Promise.reject('')
        // return this.userDAO.getAccountData(uid).then(user => {
        //     return {
        //         firstName: user.firstName,
        //         lastName: user.lastName,
        //         phone: user.phone,
        //         gender: user.gender,
        //         joinDate: user.joinDate,
        //         driverRating: undefined,
        //         driverRatingCount: undefined,
        //         riderRating: user.driverInfo?.rating,
        //         riderRatingCount: user.driverInfo?.ratingCount,
        //         profileURL: user.profileURL,
        //         licenseNum: includePrivate ? user.driverInfo?.licenseNum : undefined
        //     }
        // })
    }


    /**
     * 
     * @param uid 
     * @param fields 
     * @param imageData 
     */
    async updateRiderProfile(
        uid: string,
        fields: Partial<UserSchema>,
        imageData?: string
    ): Promise<void> {
        const newURL: string | undefined = undefined
        if (imageData) {
            //TODO: Use cloud-storage dao to upload image to cloud storage and set newURL.
        }
        await this.userDAO.updateAccountData(uid, {
            firstName: fields.firstName,
            lastName: fields.lastName,
            phone: fields.phone,
            gender: fields.gender,
            profileURL: newURL
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






}