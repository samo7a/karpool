import React, { useState } from "react";
import "./LoginPage.css";
import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";

import { signIn } from "../../auth/signin";
import { signOut } from "../../auth/signout";
import { useHistory } from "react-router";
import { Link } from "react-router-dom";

const LoginPage = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [isDriver, setIsDriver] = useState("");
  const [signinError, setSigninError] = useState("");
  const history = useHistory();
  const login = async (event) => {
    event.preventDefault();
    try {
      const res = await signIn(email, password);
      console.log(res);
      if (res !== undefined) {
        if (!res.user.emailVerified) {
          signOut();
          return;
        } else {
          //getprofile
          const uid = res.user.uid;
          console.log(uid);
          //call getprofileinfo
          //compare isDriver with isDriver
          // direct the user to the right page.
          history.push("/reset-password"); //remove it later
        }
      }
    } catch (e) {
      setSigninError(e);
      signOut();
    }
  };
  return (
    <div className="content">
      <Navbar loggedIn="false" />
      <div className="wrapper">
        <div className="left">
          <h1>Welcome back to karpool!</h1>
          <form>
            <div className="i">
              <label>Email Address</label>
              <input
                type="text"
                placeholder="Email Address"
                onChange={(event) => {
                  setEmail(event.target.value);
                }}
                maxLength="50"
              />
            </div>
            <div className="i">
              <label>Password</label>
              <input
                type="password"
                placeholder="Password"
                autoComplete="on"
                onChange={(event) => {
                  setPassword(event.target.value);
                }}
                maxLength="50"
              />
            </div>
            <Link to="/reset-password">
              <h5>Forgot your password?</h5>
            </Link>
            <div id="radio">
              <label>Are you driving?</label>
              <label className="switch">
                <input
                  type="checkbox"
                  checked={isDriver}
                  onChange={(event) => {
                    setIsDriver(!isDriver);
                  }}
                />
                <span className="slider round"></span>
              </label>
            </div>
            <button id="primaryButton" onClick={login}>
              Register
            </button>
            <p className="error">{signinError}</p>
          </form>
        </div>
        <div className="right">
          <video width="75%" loop autoPlay muted>
            <source
              src="https://firebasestorage.googleapis.com/v0/b/karpool-1ea95.appspot.com/o/vids%2Fpromo.mp4?alt=media&token=01833b23-d0f6-44ed-be5b-33a8ad92ea85"
              type="video/mp4"
            />
          </video>
          <span> source: </span>
          <a href="https://www.vecteezy.com/video/2905810-cheerful-woman-spread-arms-on-car-rooftop-under-bright-sky-at-mountain-with-nature-background-during-road-trip-on-vacation">
            https://www.vecteezy.com
          </a>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default LoginPage;
