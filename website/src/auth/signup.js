import firebase from "firebase/app";

export const signup = async (email, password) => {
  try {
    return await firebase
      .auth()
      .createUserWithEmailAndPassword(email, password);
  } catch (e) {
    throw new Error(e.message);
  }
};
