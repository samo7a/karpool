import firebase from "firebase/app";
import { getCurrentUser } from "./getCurrentUser";
import { signOut } from "./signout";

export const signup = async (email, password) => {
  try {
    await firebase.auth().createUserWithEmailAndPassword(email, password);
    getCurrentUser().sendEmailVerification();
    signOut();
  } catch (e) {
    throw new Error(e.message);
  }
};
