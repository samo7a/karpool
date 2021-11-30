import firebase from "firebase/app";
import { getCurrentUser } from "./getCurrentUser";
// import { signOut } from "./signout";

export const updateEmail = async (email, password, newEmail) => {
    try {
        await firebase
            .auth().signInWithEmailAndPassword(email, password);
        await getCurrentUser().updateEmail(newEmail)
        const user = await (await firebase.auth().signInWithEmailAndPassword(newEmail, password)).user.sendEmailVerification()

        return user;
    } catch (e) {
        throw new Error(e.message);
    }
};