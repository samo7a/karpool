import * as functions from "firebase-functions";
import * as admin from 'firebase-admin'

import { AuthenticationDAO } from "./auth/dao";
import { UserDAO } from "./database/user/dao";
import { IsBoolean, IsDate, IsNumber, IsString } from "class-validator";
import { decodeDoc } from "./database/utils";

//MARK: Setup

/**
 * Required at global scope to use class-transformer decorators in classes.
 * https://github.com/typestack/class-transformer
 */
import 'reflect-metadata';
import { AccountService } from "./features/account-management/account-service";

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

export function newAccountService(): AccountService {
    return new AccountService(
        newUserDao(),
        newAuthDAO()
    )
}

//MARK: Exposed cloud function endpoints


exports.account = require('./features/account-management/cloud-functions')










//MARK: Experimental: Delete later.

export const test = functions.https.onCall((data, context) => {

    return admin.firestore().collection('test').doc('test').get().then(doc => decodeDoc(TestClass, doc)).then(c => {
        console.log(c.name)
        console.log(c.date.toISOString())
        console.log(c.bool)
        console.log(c.num)
    })
})

class TestClass {

    @IsString()
    name: string

    @IsDate()
    date: Date

    @IsBoolean()
    bool: boolean

    @IsNumber()
    num: number

    constructor(name: string, date: Date, bool: boolean, num: number) {
        this.name = name
        this.date = date
        this.bool = bool
        this.num = num
    }

}