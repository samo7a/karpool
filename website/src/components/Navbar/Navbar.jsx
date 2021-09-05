import React from "react";
import "./Navbar.css";
import logo from "../../assets/logo.png";
import { Link, useHistory } from "react-router-dom";
import { signOut } from "../../auth/signout";

const Navbar = (props) => {
  const history = useHistory();
  let isLoggedIn = props.isLoggedIn;
  const SmartLink = ({ link, title }) => {
    var path = window.location.pathname;
    if (path === link) {
      return (
        <li className="underline">
          <Link to={link}> {title} </Link>
        </li>
      );
    } else
      return (
        <li>
          <Link to={link}> {title} </Link>
        </li>
      );
  };
  const logout = async () => {
    try {
      await signOut();
      history.push("/");
    } catch (e) {
      console.log(e.msg);
    }
  };
  const goToSignup = () => {
    history.push("/register");
  };
  const goToSignIn = async () => {
    history.push("/login");
  };
  return (
    <div id="body">
      <nav id="navbar">
        <div className="logo">
          <Link to="/">
            <img id="logo" src={logo} alt="logo" />
          </Link>
        </div>
        {isLoggedIn ? (
          <div id="navbar-links">
            <ul>
              {/* getProfile rider-home driver-home */}
              <SmartLink link="/rider-home" title="Home" />
              <SmartLink link="/account" title="Account" />
              <SmartLink link="/about-us" title="About Us" />
            </ul>
          </div>
        ) : (
          <></>
        )}
        {isLoggedIn ? (
          <div className="navbar-buttons">
            <button id="primaryButton" onClick={logout}>
              Logout
            </button>
          </div>
        ) : (
          <div className="navbar-buttons">
            <button id="secondaryButton" onClick={goToSignIn}>
              Sign In
            </button>
            <button id="primaryButton" onClick={goToSignup}>
              Sign Up
            </button>
          </div>
        )}
      </nav>
    </div>
  );
};

export default Navbar;
