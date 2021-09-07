import React from "react";
import "./DriverHomePage.css";
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
        </div>
        <Footer />
      </div>
    </>
  );
};
export default DriverHomePage;
