import { AuthenticationDAOInterface } from "../../data-access/auth/dao";
import { UserDAOInterface } from '../../data-access/user/dao'
import { DriverInfoSchema, RiderInfoSchema, tokenSchema, UserSchema, week, month/*earnings*/ } from "../../data-access/user/schema";
import { UserFieldsExternal, UserRegistrationData, DriverAddRoleInfo } from './types'
import { CloudStorageDAOInterface } from "../../data-access/cloud-storage/dao";
import { HttpsError } from "firebase-functions/lib/providers/https";
import { VehicleDAOInterface } from "../../data-access/vehicle/dao";
import { PaymentDAO } from "../../data-access/payment-dao/dao";
import { Role } from '../../data-access/user/types';
import { NotificationsDAO } from "../notifications/notificationsDAO";
import { CreditCardSchema } from "../../data-access/payment-dao/schema";

export class AccountService {

    // Database, Firebase authentication, Cloud storage, StripeAPI

    private userDAO: UserDAOInterface

    private authDAO: AuthenticationDAOInterface

    private cloudStorageDAO: CloudStorageDAOInterface

    private vehicleDAO: VehicleDAOInterface

    private paymentDAO: PaymentDAO

    private notificationsDAO: NotificationsDAO

    constructor(
        userDAO: UserDAOInterface,
        authDAO: AuthenticationDAOInterface,
        storageDAO: CloudStorageDAOInterface,
        vehicleDAO: VehicleDAOInterface,
        paymentDAO: PaymentDAO,
        notificationsDAO: NotificationsDAO
    ) {
        this.userDAO = userDAO
        this.authDAO = authDAO
        this.cloudStorageDAO = storageDAO
        this.vehicleDAO = vehicleDAO
        this.paymentDAO = paymentDAO
        this.notificationsDAO = notificationsDAO
    }

    async addRole(uid: string, driverInfo: DriverAddRoleInfo, role: Role): Promise<void> {
        const roles = {
            'Driver': true,
            'Rider': true
        }
        if (role === 'Driver') {

            const updateAccountPromise = this.userDAO.updateAccountData(uid, {
                roles: roles,
                driverInfo: {
                    rating: 0,
                    ratingCount: 0,
                    licenseExpDate: driverInfo.licenseExpDate,
                    licenseNum: driverInfo.licenseNum,
                    accountNum: driverInfo.accountNum,
                    routingNum: driverInfo.routingNum,
                    accountBalance: 0
                }
            })

            const createVehiclePromise = this.vehicleDAO.setVehicle(uid, {
                color: driverInfo.color,
                insurance: {
                    provider: driverInfo.provider,
                    coverageType: driverInfo.coverage,
                    startDate: new Date(driverInfo.startDate),
                    endDate: new Date(driverInfo.endDate)
                },
                licensePlateNum: driverInfo.plateNum,
                make: driverInfo.make,
                year: driverInfo.year,
                uid: uid
            })

            await Promise.all([updateAccountPromise, createVehiclePromise])


        } else if (role === 'Rider') {

            const stripeCustomerID = await this.paymentDAO.createCustomer()

            await this.userDAO.updateAccountData(uid, {
                roles: roles,
                riderInfo: {
                    rating: 0,
                    ratingCount: 0
                },
                stripeCustomerID: stripeCustomerID
            })

        } else {
            throw new Error(`Invalid role ${role}.`)
        }
    }

    async storeDeviceToken(uid: string, tokenIDs: tokenSchema): Promise<void> {


        const tokens = await this.notificationsDAO.getTokenList([uid])

        //console.log(tokens)


        //const arr = tokenIDs.tokenIDs

        //console.log(arr)

        if (tokens.length === 0) {
            await this.userDAO.storeUserDeviceToken(uid, tokenIDs)
        } else {

            if (!tokens.includes(tokenIDs.tokenIDs[0])) {

                tokens.push(tokenIDs.tokenIDs[0])

                const data: tokenSchema = {

                    tokenIDs: tokens
                }

                await this.userDAO.updateDeviceTokenList(uid, data)
            } else {
                console.log("Token already exist in the list")
            }
        }
    }


    async registerUser(data: UserRegistrationData): Promise<void> {

        try {
            const { downloadURL, storagePath } = await this.cloudStorageDAO.writeFile('profile-pictures', data.uid, 'jpg', data.profilePicData, 'base64', true)

            //Create credit card document if applicable.
            let stripeCustomerID: string = await this.paymentDAO.createCustomer()

            const driverInfo: DriverInfoSchema = {
                rating: 0,
                ratingCount: 0,
                licenseExpDate: data.licenseExpDate!,
                licenseNum: data.licenseNum!,
                accountNum: data.accountNum!,
                routingNum: data.routingNum!,
                accountBalance: 0
            }

            const riderInfo: RiderInfoSchema = {
                rating: 0,
                ratingCount: 0
            }

            //Create user document
            await this.userDAO.createAccountData(data.uid, {
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
                profilePicStoragePath: storagePath,
                stripeCustomerID: stripeCustomerID
            })

            //Create vehicle document if applicable
            if (data.isDriver) {
                await this.vehicleDAO.setVehicle(data.uid, {
                    color: data.color!,
                    insurance: {
                        provider: data.provider!,
                        coverageType: data.coverage!,
                        startDate: new Date(data.startDate!),
                        endDate: new Date(data.endDate!)
                    },
                    licensePlateNum: data.plateNum!,
                    make: data.make!,
                    year: data.year!,
                    uid: data.uid
                })
            }
        } catch (err) {
            await this.authDAO.deleteAccount(data.uid)
            throw err
        }


    }


    /**
     * Returns the publicly available information for a 
     * @param uid 
     * @returns 
     */
    async getUserProfile(uid: string, driver: boolean, includePrivate: boolean): Promise<UserFieldsExternal> {

        const user = await this.userDAO.getAccountData(uid)

        const hasDriverRole = user.roles['Driver'] ?? false
        const hasRiderRole = user.roles['Rider'] ?? false

        if (driver) {
            if (hasDriverRole) {
                return {
                    firstName: user.firstName,
                    lastName: user.lastName,
                    phone: user.phone,
                    profileURL: user.profileURL,
                    driverRating: user.driverInfo?.rating,
                    roles: user.roles,
                    bankAccount: {
                        routing: user.driverInfo?.routingNum ?? '',
                        account: user.driverInfo?.accountNum ?? ''
                    }
                }
            } else {
                throw new HttpsError('failed-precondition', `User ${uid} is not a driver.`)
            }

        } else {
            if (hasRiderRole) {
                return {
                    firstName: user.firstName,
                    lastName: user.lastName,
                    phone: user.phone,
                    profileURL: user.profileURL,
                    riderRating: user.riderInfo?.rating,
                    roles: user.roles
                }
            } else {
                throw new HttpsError('failed-precondition', `User ${uid} is not a rider.`)
            }
        }
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




    async editUserProfile(uid: string, phoneNum?: string, email?: string, pic?: string): Promise<void> {
        /**
         * Check if user exist
         * edit fields where necessary
         * assuming pic is given as string
        **/


        const meta = pic == undefined ? undefined : (await this.cloudStorageDAO.writeFile('profile-pictures', uid, 'jpg', pic, 'base64', true))

        const data: Partial<UserSchema> = {
            phone: phoneNum ? phoneNum : undefined,
            email: email ? email : undefined,
            profileURL: meta?.downloadURL
        }

        return this.userDAO.updateUserAccount(uid, data)
    }

    async setBankAccount(uid: string, routingNum: string, accountNum: string): Promise<void> {

        const user = await this.userDAO.getAccountData(uid)

        // const last4 = accountNum.substr(accountNum.length - 4, 4)

        await this.paymentDAO.setBankAccount(uid, user.stripeCustomerID, accountNum, routingNum)
    }

    async addCreditCard(uid: string, cardToken: string): Promise<void> {
        const user = await this.userDAO.getAccountData(uid)
        if (user.stripeCustomerID === undefined) {
            throw new HttpsError('failed-precondition', `User ${uid} needs a customer id to add a credit card.`)
        }
        return this.paymentDAO.createCreditCard(uid, user.stripeCustomerID, cardToken)
    }


    async getCreditCards(uid: string): Promise<CreditCardSchema[]> {
        return this.paymentDAO.getCreditCards(uid)
    }


    async deleteAccount(uid: string): Promise<void> {
        //delete Auth account
        //Move User record to archived users
        //Vehicle  to archive
        //Delete stripe customer
        //Delete profile picture

        const user = await this.userDAO.getAccountData(uid)

        await this.cloudStorageDAO.deleteFile(user.profilePicStoragePath)

        await this.paymentDAO.deleteCustomer(user.stripeCustomerID)

        await this.userDAO.deleteAccountData(uid)

        await this.vehicleDAO.deleteVehicle(uid)

        await this.authDAO.deleteAccount(uid)

    }


    async deleteCreditCard(uid: string, cardID: string): Promise<void> {
        const cards = await this.getCreditCards(uid)
        for (const card of cards) {
            if (card.id === cardID) {
                return this.paymentDAO.deleteCreditCard(cardID)
            }
        }
        throw new Error(`Card not a valid credit card.`)
    }

    // async setEarnings(driverID: string, date: string, tripID: string, amount: number ):Promise<void> {
    //     const data: earnings ={
    //         amount = amount,
    //         tripID = tripID,
    //         date = '2021-01-01',
    //         dayOfWeek =  days[]
    //     } 
    // }

    async getEarnings(driverID: string): Promise<(week[] | month[])[]> {
        var weekList: week[] = []
        var monthList: month[] = []
        for (let i = 0; i < 52; i++) {

            weekList.push({
                weekNum: i + 1,
                amount: 0
            })
        }
        const names: string[] = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        for (let i = 0; i < 12; i++) {
            monthList.push({
                month: names[i],
                amount: 0
            })
        }
        const allDocs = await this.userDAO.getAllEarnings(driverID)

        allDocs.map(doc => {
            const weekIndex = getWeek(doc.date.toDate(), 0)
            const monthIndex = doc.date.toDate().getMonth()

            let tempWeekAmount = weekList[weekIndex].amount

            weekList[weekIndex] = {
                weekNum: weekIndex,
                amount: tempWeekAmount += doc.amount
            }

            let tempMonthAmount = monthList[monthIndex].amount

            monthList[monthIndex] = {
                month: names[monthIndex],
                amount: tempMonthAmount += doc.amount
            }
        })

        const earningList = [weekList, monthList]

        return earningList
    }




}

/**
 * Found at: https://stackoverflow.com/a/9047794/6738247
 * Returns the week number for this date.  dowOffset is the day of week the week
 * "starts" on for your locale - it can be from 0 to 6. If dowOffset is 1 (Monday),
 * the week returned is the ISO 8601 week number.
 * @param int dowOffset
 * @return int
 */
function getWeek(date: Date, offset: number) {
    /*getWeek() was developed by Nick Baicoianu at MeanFreePath: http://www.meanfreepath.com */

    // eslint-disable-next-line no-param-reassign
    const dowOffset = typeof (offset) === 'number' ? offset : 0; //default dowOffset to zero
    var newYear = new Date(date.getFullYear(), 0, 1);
    var day = newYear.getDay() - dowOffset; //the day of week the year begins on
    day = (day >= 0 ? day : day + 7);
    var daynum = Math.floor((date.getTime() - newYear.getTime() -
        (date.getTimezoneOffset() - newYear.getTimezoneOffset()) * 60000) / 86400000) + 1;
    var weeknum;
    //if the year starts before the middle of a week
    if (day < 4) {
        weeknum = Math.floor((daynum + day - 1) / 7) + 1;
        if (weeknum > 52) {
            const nYear = new Date(date.getFullYear() + 1, 0, 1);
            let nday = nYear.getDay() - dowOffset;
            nday = nday >= 0 ? nday : nday + 7;
            /*if the next year starts before the middle of
              the week, it is week #1 of that year*/
            weeknum = nday < 4 ? 1 : 53;
        }
    }
    else {
        weeknum = Math.floor((daynum + day - 1) / 7);
    }
    return weeknum;
}