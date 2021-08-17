import React from "react";
import "./Navbar.css";
import logo from "../../assets/logo.png";
import { Link } from "react-router-dom";
const Navbar = (props) => {
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
  return (
    <div className="body">
      <nav className="navbar">
        <div className="logo">
          <img id="logo" src={logo} alt="logo" />
        </div>
        {isLoggedIn ? (
          <div className="navbar-links">
            <ul>
              <SmartLink link="/home" title="Home" />
              <SmartLink link="/account" title="Account" />
              <SmartLink link="/about-us" title="About Us" />
            </ul>
          </div>
        ) : (
          <></>
        )}
        {isLoggedIn ? (
          <div className="navbar-buttons">
            <button id="primaryButton" onClick={() => alert("Button Clicked")}>
              Logout
            </button>
          </div>
        ) : (
          <div className="navbar-buttons">
            <button
              id="secondaryButton"
              onClick={() => alert("Button Clicked")}
            >
              Sign In
            </button>
            <button id="primaryButton" onClick={() => alert("Button Clicked")}>
              Sign Up
            </button>
          </div>
        )}
      </nav>
    </div>
  );
};

export default Navbar;