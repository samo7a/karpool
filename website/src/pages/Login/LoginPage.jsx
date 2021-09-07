import React, { useState, useEffect } from "react";
import "./LoginPage.css";
import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";

import { signIn } from "../../auth/signin";
import { signOut } from "../../auth/signout";
import { useHistory } from "react-router";
import { Link } from "react-router-dom";
import { useAlert } from "react-alert";
import firebase from "firebase/app";

const LoginPage = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [isDriver, setIsDriver] = useState(false);
  const [signinError, setSigninError] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const history = useHistory();
  const alert = useAlert();
  useEffect(() => {
    signOut();
  }, []);
  const login = async (event) => {
    event.preventDefault();
    setIsLoading(true);
    try {
      const getUser = firebase.functions().httpsCallable("account-getUser");
      const res = await signIn(email, password);
      console.log("signin res", res);
      if (res !== undefined) {
        if (!res.user.emailVerified) {
          signOut();
          setIsLoading(false);
          return;
        } else {
          // getprofile
          const uid = res.user.uid;
          console.log(isDriver, uid);
          const obj = {
            uid: uid,
            driver: isDriver,
          };
          const result = await getUser(obj);
          const riderRole = result.data.roles.Rider;
          const driverRole = result.data.roles.Driver;
          console.log("Driver", driverRole);
          console.log("Rider", riderRole);
          if (isDriver === true && driverRole !== undefined) {
            // the user is driver
            setIsLoading(false);
            localStorage.setItem("role", "driver");
            alert.success("Logged in!");
            history.push("/driver-home"); //change this
            return;
          } else if (isDriver === false && riderRole !== undefined) {
            // the user is a rider
            setIsLoading(false);
            localStorage.setItem("role", "rider");
            alert.success("Logged in!");
            history.push("/rider-home"); //change this
            return;
          } else {
            // has no roles
            setIsLoading(false);
            signOut();
            setSigninError("Error Signing in!");
            return;
          }
        }
      }
    } catch (e) {
      setSigninError(e.message);
      signOut();
      setIsLoading(false);
      return;
    }
  };
  return (
    <div className="content">
      <Navbar />
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
            <button id="primaryButton" onClick={login} disabled={isLoading}>
              {isLoading && (
                <i
                  className="fa fa-refresh fa-spin"
                  style={{ marginRight: "5px" }}
                />
              )}
              {isLoading && <span>Signing in ...</span>}
              {!isLoading && <span>Sign in</span>}
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
