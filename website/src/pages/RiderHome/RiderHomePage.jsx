import React from "react";
import "./RiderHomePage.css";
import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";

const RiderHomePage = () => {
  return (
    <>
      <div className="content">
        <Navbar />
        <div className="content">
          <div className="wrapper">
            <h1> RiderHomePage</h1>
          </div>
        </div>
        <Footer />
      </div>
    </>
  );
};
export default RiderHomePage;
