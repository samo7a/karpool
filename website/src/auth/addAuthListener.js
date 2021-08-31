import firebase from "firebase/app";

export const addAuthListener = (callback) => {
  const onChange = (user) => {
    if (user) {
      callback(user);
    } else {
      callback(null);
    }
  };
  return firebase.auth().onAuthStateChanged(onChange);
};
