import React, { useState, useEffect } from "react";
import "./RiderHomePage.css";
import { Grid, Cell } from 'react-mdl';
import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";
// import axios from 'axios';
import { getCurrentUser } from '../../auth/getCurrentUser';
import Axios from "../../utils/Axios";
// const firebase = require("firebase");
// Required for side-effects
// require("firebase/functions");

//import "firebase/functions/";
// const functions = getFunctions();
// var getUser = firebase.default.functions().httpsCallable('account-getUser');
// addMessage({ text: messageText })
//   .then((result) => {
//     // Read result of the Cloud Function.
//     var sanitizedMessage = result.data.text;
//   });
//const getUser = httpsCallable('account-getUser');

const RiderHomePage = () => {
  const [profilePicUrl, setProfilePicUrl] = useState("");
  const [rating, setRating] = useState(0.0);
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [phoneNum, setPhoneNum] = useState("");

  useEffect(() => {
    const getData = async () => {

      const user = await getCurrentUser();
      console.log(user)
      const obj = { uid: user.uid, driver: false }

      try {
        const res = await Axios.post("/account-getUser", obj);
        console.log(res);
        setFirstName(res.data.firstName)
        setLastName()
      } catch (e) {
        console.log(e);
      }
    }

    getData();


  }, []);
  return (
    <>
      <div className="content">
        <Navbar />
        <div className="content">
          <div className="wrapper">
            <h1> Rider Home Page</h1>
          </div>
          <div style={{ width: '100%', margin: 'auto' }}>
            <Grid className="landing-grid">
              <Cell col={12}>
                <img
                  src={profilePicUrl}
                  alt="avatar"
                  className="avatar-img"
                />
                <div className="banner-text">
                  <h1>{firstName} {lastName}</h1>
                  <hr />
                  <p>Phone Number: {phoneNum}</p>
                  <hr />
                  <p>Display Stars Rating: {rating}</p>
                  <hr />
                  <p>Display Most Recent Ride:</p>
                  <hr />
                  <p>Display Payment Method:</p>
                </div>
              </Cell>
            </Grid>
          </div>
        </div>
        <Footer />
      </div>
    </>
  );
};
export default RiderHomePage;
