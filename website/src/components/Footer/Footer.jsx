import React from "react";
import "./Footer.css";
import googlePlay from "../../assets/googleplay.png";
import appStore from "../../assets/appstore.svg";

const Footer = () => {
  return (
    <div className="body">
      <footer id="footer">
        <div id="rights">
          <h6>&copy; 2021 Karpool. All rights reserved</h6>
        </div>
        <div id="pictures">
          <img id="android" src={googlePlay} alt="android" />
          <img id="ios" src={appStore} alt="iphone" />
        </div>
      </footer>
    </div>
  );
};

export default Footer;
