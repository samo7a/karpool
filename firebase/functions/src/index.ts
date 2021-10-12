import * as admin from 'firebase-admin'

import { AuthenticationDAO } from "./data-access/auth/dao";
import { UserDAO } from "./data-access/user/dao";
import { PaymentDAO } from "./data-access/payment-dao/dao";
import { CloudStorageDAO } from "./data-access/cloud-storage/dao";
import { VehicleDAO } from "./data-access/vehicle/dao";
import { TripDAO } from "./data-access/trip/dao";
import { AccountService } from "./features/account-management/account-service";
import { TripService } from "./features/trip/trip-service";
import { getEnv } from "./utils/env-config";
import { RouteDAO, RouteDAOInterface } from "./data-access/route/dao";

//MARK: Setup

/**
 * Required at global scope to use class-transformer decorators in classes.
 * https://github.com/typestack/class-transformer
 */
import 'reflect-metadata';
import { NotificationsDAO } from './features/notifications/notificationsDAO';

admin.initializeApp()
admin.firestore().settings({ ignoreUndefinedProperties: true })


/**
 * MARK: Classes shared around the system.
 */

export function newUserDao(): UserDAO {
    return new UserDAO(admin.firestore())
}

export function newAuthDAO(): AuthenticationDAO {
    return new AuthenticationDAO(admin.auth())
}

export function newCloudStorageDAO(): CloudStorageDAO {
    return new CloudStorageDAO(admin.storage())
}

export function newVehicleDAO(): VehicleDAO {
    return new VehicleDAO(admin.firestore())
}

export function newPaymentDAO(): PaymentDAO {
    const stripe = getEnv().stripe
    return new PaymentDAO(stripe.public_key, stripe.private_key, admin.firestore())
}


export function newTripDAO(): TripDAO {
    return new TripDAO(admin.firestore(), admin.database())
}

export function newNotificationDAO(): NotificationsDAO {
    return new NotificationsDAO(admin.firestore())
}

export function newRouteDAO(): RouteDAOInterface {
    // return new DirectionsDAOMock()
    return new RouteDAO(
        admin.firestore(),
        getEnv().directions_api.private_key
    )
}

export function newAccountService(): AccountService {
    return new AccountService(
        newUserDao(),
        newAuthDAO(),
        newCloudStorageDAO(),
        newVehicleDAO(),
        newPaymentDAO(),
        newNotificationDAO()
    )
}

export function newTripService(): TripService {
    return new TripService(
        newUserDao(),
        newTripDAO(),
        newRouteDAO(),
        newNotificationDAO()
    )
}


//MARK: Exposed cloud function endpoints

exports.trip = require('./features/trip/cloud-functions')

exports.account = require('./features/account-management/cloud-functions')

exports.notification = require('./features/notifications/notifications')




import { searchTrips as t } from './z-playground';
export const searchTrips = t