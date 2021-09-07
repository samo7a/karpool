import React, { useState, useEffect } from "react";
import "./ResetPasswordPage.css";
import { useHistory } from "react-router";
import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";
import firebase from "firebase/app";
import { signOut } from "../../auth/signout";
import { useAlert } from "react-alert";

const ResetPasswordPage = () => {
  const [email, setEmail] = useState("");
  const [resetError, setResetError] = useState("");
  const history = useHistory();
  const alert = useAlert();

  useEffect(() => {
    signOut();
  }, []);
  const resetPassword = async (event) => {
    event.preventDefault();
    setResetError("");
    try {
      const res = await firebase.auth().sendPasswordResetEmail(email);
      console.log(res);
      alert.success("Email has been sent!");
      history.push("/login");
    } catch (e) {
      setResetError(e.message);
    }
  };
  return (
    <div className="cont">
      <Navbar />
      <div id="int">
        <div className="wrap">
          <h1>Enter your email to reset your password!</h1>
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
            <button id="primaryButton" onClick={resetPassword}>
              Reset Password
            </button>
            <p className="error">{resetError}</p>
          </form>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default ResetPasswordPage;
