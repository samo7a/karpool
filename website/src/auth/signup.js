import firebase from "firebase/app";
import { getCurrentUser } from "./getCurrentUser";
// import { signOut } from "./signout";

export const signup = async (email, password) => {
  try {
    const user = await firebase
      .auth()
      .createUserWithEmailAndPassword(email, password);
    await getCurrentUser().sendEmailVerification();
    return user;
  } catch (e) {
    throw new Error(e.message); 
  }
};
