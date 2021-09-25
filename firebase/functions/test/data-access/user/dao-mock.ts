import { UserDAOInterface } from "../../../src/data-access/user/dao";
import { UserSchema } from "../../../src/data-access/user/schema";
import { User } from "../../../src/models-shared/user";


export class UserDAOMock implements UserDAOInterface {


    createAccountData(uid: string, info: UserSchema): Promise<void> {
        throw new Error("Method not implemented.");
    }
    updateAccountData(uid: string, fields: Partial<UserSchema>): Promise<void> {
        throw new Error("Method not implemented.");
    }
    getAccountData(uid: string): Promise<User> {
        throw new Error("Method not implemented.");
    }
    deleteAccountData(uid: string): Promise<void> {
        throw new Error("Method not implemented.");
    }



}