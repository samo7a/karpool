import React from "react";
import "./DriverHomePage.css";
import { Grid, Cell } from 'react-mdl';
import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";

const DriverHomePage = () => {
  return (
    <>
      <div className="content">
        <Navbar />
        <div className="content">
          <div className="wrapper">
            <h1> Driver Home Page</h1>
          </div>
          <div style={{ width: '100%', margin: 'auto' }}>
            <Grid className="landing-grid">
              <Cell col={12}>
                <img
                  src="https://cdn0.iconfinder.com/data/icons/social-media-network-4/48/male_avatar-512.png"
                  alt="avatar"
                  className="avatar-img"
                />
                <div className="banner-text">
                  <h1>Bob Smith</h1>
                  <hr />
                  <p>(123) 456-7890</p>
                  <hr />
                  <p>Display Stars Rating:</p>
                  <hr />
                  <p>This Week's Earnings:</p>
                  <hr />
                  <p>Display Most Recent Deposit:</p>
                  <hr />
                  <p>Display Most Recent Ride:</p>
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
