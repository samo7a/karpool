
// import { AuthenticationDAOInterface } from "../../auth/dao";
// import { UserDAOInterface } from "../../dao/user/dao";
// import { TripResult, ReviewResult } from "../../models-shared/review";
// import { DriverRegistrationInfo, RiderRegistrationInfo } from "../../models-shared/register";
// import { RiderInfo, DriverInfo, User } from '../../models-shared/user'

// export class DriverService {

//     private userDAO: UserDAOInterface

//     private authDAO: AuthenticationDAOInterface

//     constructor(
//         userDAO: UserDAOInterface,
//         authDAO: AuthenticationDAOInterface
//     ) {
//         this.userDAO = userDAO
//         this.authDAO = authDAO
//     }


//     /**
//      * Registers a user as a driver. If the user has not already made a rider account, this will create 
//      * their account data, otherwise it will just add the driver specified account info and won't override their existing account info (firstName etc.).
//      * @param info Fields required for registering the user as a rider.
//      */
//     async register(info: DriverRegistrationInfo): Promise<void> {
//         const driverInfo: DriverInfo = {
//             isDriver: true,
//             licenseNum: info.licenseNum,
//             rating: 0,
//             ratingCount: 0
//         }

//         await this.authDAO.registerAccount(info.email, info.password).then(userID => {
//             const user = new User(info.firstName, info.lastName, info.phone, info.email, info.gender, info.dob, info.address, info.joinDate, driverInfo, undefined)
//             return this.userDAO.createUserInfo(userID, user)
//         }).catch(async err => {
//             if (err.code === 'already-exists') {
//                 const userID = await this.authDAO.getUserID(info.email)
//                 return this.userDAO.updateUserInfo(userID, { driverInfo: driverInfo })
//             } else {
//                 return Promise.reject(err)
//             }
//         })

//     }

//     getProfile(id: string): Promise<

//         /**
//          * 
//          * @param driverID 
//          * @param authorID 
//          * @param rating 
//          * @param content 
//          * @returns 
//          */
//         writeReview(
//             driverID: string,
//             authorID: string,
//             rating: number,
//             content: string
//         ): Promise<void> {
//             return Promise.reject(new Error('Unimplemented.'))
//         }

// /**
//  * 
//  * @param riderID 
//  * @param limit 
//  */
// getReviews(
//     riderID: string,
//     limit ?: string
// ): Promise < ReviewResult[] > {
//     return Promise.reject(new Error('Unimplemented.'))
// }

// /**
//  * 
//  * @param startDate 
//  * @param endDate 
//  * @param limit 
//  */
// getTripHistory(
//     startDate: Date,
//     endDate: Date,
//     limit ?: number
// ): Promise < TripResult[] > {
//     return Promise.reject(new Error('Unimplemented.'))
// }

// /**
//  * 
//  * @param tripID 
//  * @param riderID 
//  */
// bookTrip(
//     tripID: string,
//     riderID: string
// ): Promise < string > {
//     return Promise.reject(new Error('Unimplemented.'))
// }

// /**
//  * 
//  * @param driverID 
//  */
// getDriverProfile(
//     driverID: string
// ): Promise < void> {
//     return Promise.reject(new Error('Unimplemented.'))
// }


// }