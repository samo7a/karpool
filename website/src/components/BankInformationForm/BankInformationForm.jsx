import React from "react";
import "./BankInformationFrom.css";
import {
  checkAccountNumber,
  checkRoutingNumber,
} from "../../utils/InputValidators";
import stripeImg from "../../assets/stripe_secure.png";

const BankInformationForm = (props) => {
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
              if (obj.valid === false) props.setRoutingNumberError(obj.msg);
              else props.setRoutingNumberError("");
              props.setRoutingNumber(event.target.value);
            }}
            maxLength="9"
          />
        </div>
        <p className="error">{props.routingNumberError}</p>
        <div className="i">
          <label>Account Number</label>
          <input
            type="text"
            placeholder="Personal Account Number"
            onChange={(event) => {
              const obj = checkAccountNumber(event.target.value);
              if (obj.valid === false) props.setAccountNumberError(obj.msg);
              else props.setAccountNumberError("");
              props.setAccountNumber(event.target.value);
            }}
            maxLength="12"
          />
        </div>
        <p className="error">{props.accountNumberError}</p>
        <img alt="Powered by stripe" src={stripeImg} id="stripe-img" />
      </div>
    </div>
  );
};
export default BankInformationForm;
