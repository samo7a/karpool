import firebase from "firebase/app";

export const signIn = async (email, password) => {
  try {
    return await firebase.auth().signInWithEmailAndPassword(email, password);
  } catch (e) {
    throw new Error("Error Signing in");
  }
};
