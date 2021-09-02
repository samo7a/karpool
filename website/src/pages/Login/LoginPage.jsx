import React, { useState } from "react";
import "./LoginPage.css";
import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";
import vid from "../../assets/promo.mp4";

const LoginPage = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [isDriver, setIsDriver] = useState("");
  const [signupError, setSignupError] = useState("");
  const login = () => {};
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
            <p className="error">{signupError}</p>
          </form>
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
      <Footer />
    </div>
  );
};

export default LoginPage;
