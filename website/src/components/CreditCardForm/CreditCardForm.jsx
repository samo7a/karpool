import React, { useState } from "react";
import "./CreditCardForm.css";
import {
  checkRiderSignup,
  checkFirstName,
  checkLastName,
  checkEmail,
  checkPhoneNumber,
  checkAge,
  checkGender,
  checkPassword,
  checkConfirmPassword,
} from "../../utils/InputValidators";
import stripeImg from "../../assets/stripe_secure.png";
import { CardElement, useStripe, useElements } from "@stripe/react-stripe-js";

const CreditCardForm = (props) => {
  const [creditCardError, setCreditCardError] = useState("");
  const [registerError, setRegisterError] = useState("");

  const stripe = useStripe();
  const elements = useElements();

  const firstName = props.firstName;
  const lastName = props.lastName;
  const email = props.email;
  const phone = props.phone;
  const dob = props.dateOfBirth;
  const gender = props.gender;
  const password = props.password;
  const confirmPassword = props.confirmPassword;
  const isDriver = props.isDriver;

  const registerRider = async (event) => {
    event.preventDefault();
    props.setFirstNameError("");
    props.setLastNameError("");
    props.setEmailError("");
    props.setPhoneError("");
    props.setDateOfBirthError("");
    props.setGenderError("");
    props.setPasswordError("");
    props.setConfirmPasswordError("");
    setCreditCardError("");
    setRegisterError("");

    //TODO
    // const url = props.handleFileUpload(); //url of the uploaded file.
    // if (errorUploading the file) {
    //   return;
    // }

    const isValid = checkRiderSignup(
      firstName,
      lastName,
      email,
      phone,
      dob,
      gender,
      password,
      confirmPassword,
      isDriver
    );
    if (!isValid) {
      setRegisterError(
        "Please fill all the required data or fix the format of the input!"
      );
      props.setFirstNameError(checkFirstName(firstName).msg);
      props.setLastNameError(checkLastName(lastName).msg);
      props.setEmailError(checkEmail(email).msg);
      props.setPhoneError(checkPhoneNumber(phone).msg);
      props.setDateOfBirthError(checkAge(dob).msg);
      props.setGenderError(checkGender(gender).msg);
      props.setPasswordError(checkPassword(password).msg);
      props.setConfirmPasswordError(
        checkConfirmPassword(confirmPassword, password).msg
      );
      return;
    } else setRegisterError("");
    const cardElement = elements.getElement(CardElement);
    console.log(cardElement);
    const { error, paymentMethod } = await stripe.createPaymentMethod({
      type: "card",
      card: cardElement,
    });
    if (error) {
      setCreditCardError(error.message);
      setRegisterError(
        "Please fill all the required data or fix the format of the input!"
      );
      return;
    } else {
      console.log("[PaymentMethod]", paymentMethod);
      setCreditCardError("");
      setRegisterError("");
    }
    //TODO
    // axios post request to the signup endpoint
    const obj = {
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phone,
      dateOfBirth: dob,
      gender: gender,
      password: password,
      isDriver: isDriver,
    };
    console.log(obj);
    return "yeah or nuh";
  };

  return (
    <>
      <div id="credit-card-form">
        <h4>Credit Card Information</h4>
        <CardElement
          // onChange={handleSomething}
          id="card-element"
          options={{
            style: {
              base: {
                fontSize: "16px",
                color: "#fff",
                "::placeholder": {
                  color: "#87bbfd",
                },
              },
              invalid: {
                color: "red",
                iconColor: "red",
              },
              complete: {
                color: "green",
              },
            },
            hidePostalCode: true,
          }}
        />
        <p className="error">{creditCardError}</p>
        <img alt="Powered by stripe" src={stripeImg} id="stripe-img" />
      </div>

      <button id="primaryButton" onClick={registerRider}>
        Register
      </button>
      <p className="error">{registerError}</p>
    </>
  );
};

export default CreditCardForm;
