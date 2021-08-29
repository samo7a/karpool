import React, { useState, forwardRef, useImperativeHandle } from "react";
import "./BankInformationFrom.css";
import {
  checkAccountNumber,
  checkRoutingNumber,
} from "../../utils/InputValidators";
import stripeImg from "../../assets/stripe_secure.png";

const BankInformationForm = forwardRef((props, ref) => {
  const [routingNumber, setRoutingNumber] = useState("");
  const [accountNumber, setAccountNumber] = useState("");
  const [routingNumberError, setRoutingNumberError] = useState("");
  const [accountNumberError, setAccountNumberError] = useState("");

  useImperativeHandle(ref, () => ({
    setBankError(val) {
      setAccountNumberError(val);
      setRoutingNumberError(val);
    },
    checkBankInfo() {
      return (
        checkAccountNumber(accountNumber).valid && checkRoutingNumber(routingNumber).valid
      );
    },
    checkAccountNumber1() {
      const obj = checkAccountNumber(accountNumber);
      if (obj.valid === false) {
        setAccountNumberError(obj.msg);
        return false;
      } else {
        setAccountNumberError("");
        return true;
      }
    },
    checkRoutingNumber1() {
      const obj = checkRoutingNumber(routingNumber);
      if (obj.valid === false) {
        setRoutingNumberError(obj.msg);
        return false;
      } else {
        setRoutingNumberError("");
        return true;
      }
    },
  }));
  return (
    <div id="bank-form">
      <h4>Bank information form</h4>
      <div id="bank-input">
        <div className="i">
          <label>Routing Number</label>
          <input
            type="text"
            placeholder="Bank Routing Number"
            onChange={(event) => {
              const obj = checkRoutingNumber(event.target.value);
              if (obj.valid === false) setRoutingNumberError(obj.msg);
              else setRoutingNumberError("");

              setRoutingNumber(event.target.value);
              props.setRoutingNumber(event.target.value);
            }}
            maxLength="9"
          />
        </div>
        <p className="error">{routingNumberError}</p>
        <div className="i">
          <label>Account Number</label>
          <input
            type="text"
            placeholder="Personal Account Number"
            onChange={(event) => {
              const obj = checkAccountNumber(event.target.value);
              if (obj.valid === false) setAccountNumberError(obj.msg);
              else setAccountNumberError("");

              setAccountNumber(event.target.value);
              props.setAccountNumber(event.target.value);
            }}
            maxLength="12"
          />
        </div>
        <p className="error">{accountNumberError}</p>
        <img alt="Powered by stripe" src={stripeImg} id="stripe-img" />
      </div>
    </div>
  );
});

export default BankInformationForm;
