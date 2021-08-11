import React from "react";
import "./Navbar.css";
import logo from "../assets/logo.png";
import { Link } from "react-router-dom";
const Navbar = (props) => {
  let isLoggedIn = props.isLoggedIn;
  return (
    <div className="body">
      <nav className="navbar">
        <div className="logo">
          <img id="logo" src={logo} alt="logo" />
        </div>
        {isLoggedIn ? (
          <div className="navbar-links">
            <ul>
              <li>
                <Link to="/home"> Home </Link>
              </li>
              <li>
                <Link to="/account"> Account </Link>
              </li>
              <li>
                <Link to="/about-us"> About Us </Link>
              </li>
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
