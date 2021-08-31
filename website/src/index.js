import React from "react";
import ReactDOM from "react-dom";
import firebase from "firebase/app";
import "firebase/auth";
import "./index.css";
import App from "./App";
import reportWebVitals from "./reportWebVitals";

const firebaseConfig = {
  apiKey: "AIzaSyCVE9JLkkJC4kzFiz6nD1qffFH9Wm2GLfY",
  authDomain: "karpool-1ea95.firebaseapp.com",
  projectId: "karpool-1ea95",
  storageBucket: "karpool-1ea95.appspot.com",
  messagingSenderId: "532093429300",
  appId: "1:532093429300:web:f8020104c45e63e4790c61",
  measurementId: "G-X2QYSH2WEV",
};
firebase.initializeApp(firebaseConfig);
ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById("root")
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
