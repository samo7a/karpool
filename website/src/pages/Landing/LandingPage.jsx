import React, { useEffect } from "react";
import "./LandingPage.css";
import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";
import vid from "../../assets/promo.mp4";
import icon3 from "../../assets/icon3.jpg";
import { signOut } from "../../auth/signout";
import { useHistory } from "react-router-dom";

const LandingPage = () => {
  let isLoggedIn = false;
  const history = useHistory();
  useEffect(() => {
    signOut();
  }, []);
  return (
    <>
      <div className="content">
        <Navbar isLoggedIn={isLoggedIn} />
        <div className="wrapper">
          <div className="left">
            <article className="post">
              <h1>Share a Ride, Save The Planet!</h1>
              <p className="para">
                Join us now and help us to raise the awarness of carpooling as a
                transportation option. Our Application is designed to cut down
                the number of cars on the road. This will reduce the carbon
                emissions into the air resulting in a cleaner environment.
              </p>
            </article>
          </div>

          <div className="right">
            <video width="75%" loop autoPlay muted>
              <source src={vid} type="video/mp4" />
            </video>
            <span> source: </span>
            <a href="https://www.vecteezy.com/video/2905810-cheerful-woman-spread-arms-on-car-rooftop-under-bright-sky-at-mountain-with-nature-background-during-road-trip-on-vacation">
              https://www.vecteezy.com
            </a>
          </div>
        </div>
        <div className="wrapper">
          <div className="left">
            <article className="post">
              <h1>Find a ride in a convenient, fast, and affordable way!</h1>
              <h2> How Karpool works?</h2>
              <p className="para">
                We will look for rides along your route to fill your empty seats
                in the car, so you and the rider can save money, and contribute
                in the green movement. It is a win-win-win situation! <br /> So
                What are you waiting for? Signup now!
              </p>
            </article>
            <button
              id="secondaryButton"
              onClick={() => {
                history.push("/register");
              }}
            >
              Sign Up
            </button>
          </div>

          <div className="right">
            <img src={icon3} alt="how-karpool-works" width="100%" />
          </div>
        </div>
        <Footer />
      </div>
    </>
  );
};

export default LandingPage;
