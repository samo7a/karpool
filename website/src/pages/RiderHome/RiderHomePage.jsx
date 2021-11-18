import React, { useState, useEffect } from "react";
import "./RiderHomePage.css";
import { Grid, Cell } from 'react-mdl';
import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";
import { RatingView } from 'react-simple-star-rating'

import { getCurrentUser } from '../../auth/getCurrentUser';

import firebase from "firebase";

const RiderHomePage = () => {
  const [riderInfo, setRiderInfo] = useState({})
  const [riderPayment, setRiderPayment] = useState({})
  const [riderTrips, setRiderTrips] = useState({})
  const [ratingValue, setRatingValue] = useState(0.0);
  const [name, setName] = useState("");
  const [phone, setPhone] = useState("");
  const [profilePic, setProfilePic] = useState("")
  // const ratingValue = Math.round(riderInfo.riderRating);

  useEffect(() => {
    const getUserInfo = async () => {
      const getRiderInfo = firebase.functions().httpsCallable('account-getUser');
      const data = {
        uid: getCurrentUser().uid,
        driver: false
      }
      const result = await getRiderInfo(data);
      console.log(result.data)
      const user = result.data;
      setName(user.firstName + " " + user.lastName);
      setPhone(user.phone);
      setProfilePic(user.profileURL);
      setRatingValue(user.riderRating);
      setRiderInfo(user.data)
      console.log(riderInfo)

      // const obj = { uid: user, driver: false }
    }
    getUserInfo();

  }, []);

  return (
    <>
      <div className="content">
        <Navbar />
        <h1> Rider Home</h1>
        <div className="content">
          <div>
            <Grid className="landing-grid">
              <Cell col={12}>
                <img
                  src={profilePic}
                  alt="avatar"
                  className="avatar-img"
                />
                <div className="banner-text">
                  <h1>Hi {name}!</h1>
                  <hr />
                  <p>Phone Number: {phone}</p>
                  <hr />
                  <RatingView ratingValue={ratingValue} /* RatingView Props */ />
                  {/* <p>Rating:
                    {[...Array(ratingValue)].map(star => {
                      return <FaStar color="#ffc107" />
                    })}
                  </p> */}
                  <hr />
                  {/* <p>Most Recent Ride:riderTrips.destination</p> */}
                  {/* <hr /> */}
                  {/* <p>Default Credit Card:riderTrips.destination</p> */}
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
