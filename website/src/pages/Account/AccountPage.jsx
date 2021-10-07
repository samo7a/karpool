import React from "react";
import "./AccountPage.css";

import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";
import BankInformationForm from "../../components/BankInformationForm/BankInformationForm";
import CarInformationForm from "../../components/CarInformationForm/CarInformationForm";
import CarInsuranceForm from "../../components/CarInsuranceForm/CarInsuranceForm";

import {
  checkFirstName,
  checkLastName,
  checkEmail,
  checkPhoneNumber, 
  checkAge,
  checkPassword,
  checkConfirmPassword,
  checkGender,
  checkDriverSignUp,
  checkRiderSignup,
} from "../../utils/InputValidators";

const AccountPage = () => {
  return (
    <>
      <div className="content">
        <Navbar />
        <div className="content">
          <div className="wrapper">
            <h1> Account Page</h1>
            
          </div>
        </div>
        <Footer />
      </div>
    </>
  );
};
export default AccountPage;
