
import { AuthenticationDAOInterface } from "../../auth/dao";
import { UserDAOInterface } from '../../database/user/dao'
import { TripResult, ReviewResult } from "../../models-shared/review";
import { RiderRegistrationInfo } from "../../models-shared/register";
import { UserFieldsExternal } from '../../models-shared/user'
import { Role } from "../../database/user/types";
import { UserSchema } from "../../database/user/schema";

export class RiderService {

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
    async register(info: RiderRegistrationInfo): Promise<void> {
        const riderInfo = { //These info objects are to help with readability for constructing the user class.
            isRider: true,
            rating: 0,
            ratingCount: 0
        }

        await this.authDAO.registerAccount(info.email, info.password).then(userID => {
            return this.userDAO.createUserInfo(userID, {
                firstName: info.firstName,
                lastName: info.lastName,
                phone: info.phone,
                email: info.email,
                gender: info.gender,
                dob: info.dob,
                address: info.address,
                driverInfo: undefined,
                riderInfo: riderInfo
            })
        }).catch(async err => {
            if (err.code === 'already-exists') {
                const userID = await this.authDAO.getUserID(info.email)

                const userData: Partial<UserSchema> = {
                    riderInfo: {
                        rating: riderInfo.rating,
                        ratingCount: riderInfo.ratingCount
                    }
                }
                const partialKey: Role = 'Rider' //Update roles dictionary. Since roles is a nested dictionary, to set a single key without overwriting the others, we have to use dot notation. We also have to case the userData as any to insert the special key.
                const copy = (userData as any)
                copy[`roles.${partialKey}`] = true

                return this.userDAO.updateUserInfo(userID, userData)
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
    getProfile(uid: string, includePrivate: boolean): Promise<UserFieldsExternal> {
        return this.userDAO.getUserInfo(uid).then(user => {
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
    async updateProfile(uid: string, fields: Partial<UserSchema>): Promise<void> {
        await this.userDAO.updateUserInfo(uid, {
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
    deleteProfile(uid: string): Promise<void> {
        return Promise.reject(new Error('Unimplemented.'))
    }



    /**
     * 
     * @param encryptedData 
     */
    setupPaymentMethod(encryptedData: string): Promise<void> {
        return Promise.reject(new Error('Unimplemented.'))
    }

    /**
     * 
     * @param driverID 
     * @param rating 
     * @param review 
     */
    writeReview(
        driverID: string,
        authorID: string,
        rating: number,
        content: string
    ): Promise<void> {
        return Promise.reject(new Error('Unimplemented.'))
    }


    /**
     * 
     * @param riderID 
     * @param limit 
     */
    getReviews(
        riderID: string,
        limit?: string
    ): Promise<ReviewResult[]> {
        return Promise.reject(new Error('Unimplemented.'))
    }

    /**
     * 
     * @param startDate 
     * @param endDate 
     * @param limit 
     */
    getTripHistory(
        startDate: Date,
        endDate: Date,
        limit?: number
    ): Promise<TripResult[]> {
        return Promise.reject(new Error('Unimplemented.'))
    }

    /**
     * 
     * @param tripID 
     * @param riderID 
     */
    bookTrip(
        tripID: string,
        riderID: string
    ): Promise<string> {
        return Promise.reject(new Error('Unimplemented.'))
    }

    /**
     * 
     * @param driverID 
     */
    getDriverProfile(
        driverID: string
    ): Promise<void> {
        return Promise.reject(new Error('Unimplemented.'))
    }


}