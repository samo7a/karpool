

import { AuthenticationDAOInterface } from "../../auth/dao";
import { UserDAOInterface } from '../../data-access/user/dao'
import { UserRegistrationData } from './types'
import { DriverInfoSchema, RiderInfoSchema, UserSchema } from "../../data-access/user/schema";
import { UserFieldsExternal } from '../../features/account-management/types'
import { CloudStorageDAOInterface } from "../../data-access/cloud-storage/dao";
import { HttpsError } from "firebase-functions/lib/providers/https";
import { VehicleDAOInterface } from "../../data-access/vehicle/dao";

export class AccountService {

    // Database, Firebase authentication, Cloud storage, StripeAPI

    private userDAO: UserDAOInterface

    private authDAO: AuthenticationDAOInterface

    private cloudStorageDAO: CloudStorageDAOInterface

    private vehicleDAO: VehicleDAOInterface

    constructor(
        userDAO: UserDAOInterface,
        authDAO: AuthenticationDAOInterface,
        storageDAO: CloudStorageDAOInterface,
        vehicleDAO: VehicleDAOInterface,
    ) {
        this.userDAO = userDAO
        this.authDAO = authDAO
        this.cloudStorageDAO = storageDAO
        this.vehicleDAO = vehicleDAO
    }


    async registerUser(data: UserRegistrationData): Promise<void> {
        await this.authDAO.registerAccount(data.email, data.password).then(async uid => {

            const { downloadURL } = await this.cloudStorageDAO.writeFile('profile-pictures', uid, 'jpg', data.profilePicData, 'base64', true)

            const driverInfo: DriverInfoSchema = {
                rating: 0,
                ratingCount: 0,
                licenseExpDate: data.licenseExpDate!,
                licenseNum: data.licenseNum!
            }

            const riderInfo: RiderInfoSchema = {
                rating: 0,
                ratingCount: 0,
                stripeToken: data.stripeToken!
            }

            //Create user document
            await this.userDAO.createAccountData(uid, {
                firstName: data.firstName,
                lastName: data.lastName,
                phone: data.phone,
                email: data.email,
                gender: data.gender,
                dob: data.dob,
                joinDate: new Date(),
                roles: data.isDriver ? { 'Driver': true } : { 'Rider': true },
                driverInfo: data.isDriver ? driverInfo : undefined,
                riderInfo: data.isDriver ? undefined : riderInfo,
                profileURL: downloadURL,
                bankAccount: {
                    accountNum: data.accountNum!,
                    routingNum: data.routingNum!
                }

            })

            //Create vehicle document if applicable
            if (data.isDriver) {
                this.vehicleDAO.createVehicle({
                    color: data.color!,
                    insurance: {
                        provider: data.provider!,
                        coverageType: data.coverage!,
                        startDate: data.startDate!,
                        endDate: data.endDate!
                    },
                    licensePlateNum: data.plateNum!,
                    make: data.make!,
                    year: data.year!,
                    uid: uid
                })
            }

            //Create credit card document if applicable.
            if (!data.isDriver) {
                this.userDAO.createCreditCard({
                    cardNum: data.cardNum!,
                    cvc: data.cardCVC!,
                    expDate: data.cardExpDate!,
                    uid: uid
                })
            }

        }).catch(err => {
            throw new HttpsError('internal', err.message)
        })
    }


    /**
     * Returns the publicly available information for a 
     * @param uid 
     * @returns 
     */
    async getUserProfile(uid: string, driver: boolean, includePrivate: boolean): Promise<UserFieldsExternal> {

        return Promise.reject('') //Remove this later

        // const user = await this.userDAO.getAccountData(uid)

        // return {
        //     firstName: user.firstName,
        //     lastName: user.lastName,
        //     phone: user.phone,
        //     gender: user.gender,
        //     dob: user.dob,
        //     joinDate: user.joinDate,
        //     driverInfo: {
        //         licenseNum: includePrivate ? user.driverInfo?.licenseNum : undefined,


        //     }
        // }
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