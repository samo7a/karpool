import React, { useState, useEffect } from "react";
import "./DriverHomePage.css";
import { Grid, Cell } from 'react-mdl';
import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";
import { RatingView } from 'react-simple-star-rating'

import { getCurrentUser } from '../../auth/getCurrentUser';

import firebase from "firebase";

const DriverHomePage = () => {
  const [driverInfo, setDriverInfo] = useState({})
  const [driverEarnings, setDriverEarnings] = useState({})
  const [driverTrips, setDriverTrips] = useState({})
  const [ratingValue, setRatingValue] = useState(0.0);
  const [name, setName] = useState("");
  const [phone, setPhone] = useState("");
  const [profilePic, setProfilePic] = useState("")
  //const ratingValue = Math.round(driverInfo.driverRating);

  useEffect(() => {
    const getUserInfo = async () => {
      const getDriverInfo = firebase.functions().httpsCallable('account-getUser');
      const data = {
        uid: getCurrentUser().uid,
        driver: true
      }
      const result = await getDriverInfo(data);
      console.log(result.data)
      const user = result.data;
      setName(user.firstName + " " + user.lastName);
      setPhone(user.phone);
      setProfilePic(user.profileURL);
      setRatingValue(user.riderRating);
      setDriverInfo(user.data)
      console.log(driverInfo)

    }
    getUserInfo();

  }, []);

  return (
    <>
      <div className="content">
        <Navbar />
        <div className="content">
          <div className="wrapper">
            <h1> Driver Home</h1>
          </div>
          <div style={{ width: '100%', margin: 'auto' }}>
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
                  {/* <hr /> */}
                  {/* <p>This Week's Earnings:{driverEarnings.amount}</p> */}
                  {/* <hr /> */}
                  {/* <p>Most Recent Deposit:{driverEarnings.amount}</p> */}
                  {/* <hr /> */}
                  {/* <p>Most Recent Drive: {driverTrips.destination}</p> */}
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
export default DriverHomePage;
