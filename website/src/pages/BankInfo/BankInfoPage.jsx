import React, { useState, useRef, useEffect } from "react";
import "./BankInfoPage.css";

import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";
import BankInformationForm from "../../components/BankInformationForm/BankInformationForm";
import firebase from "firebase";

const BankInfoPage = () => {
    const [accountNumber, setAccountNumber] = useState("");
    const [routingNumber, setRoutingNumber] = useState("");
    const [Message, setMessage] = useState("");
    const bankInfoRef = useRef();
    async function setBankAccount() {
        setMessage("");
        await firebase.functions().httpsCallable('account-setBankAccount')({
            accountNum: accountNumber,
            routingNum: routingNumber
        }).then(() => {
            setAccountNumber("");
            setRoutingNumber("");
            setMessage("Bank Info Successfully Updated!");
        }).catch(() => {
            setMessage("Bank Info Not Updated!");
        });
    };

    return (
        <>
            <div className="content">
                <Navbar />
                <h1>Update Bank Info</h1>
                <div className="content">
                    <div id="bank-info">
                        <BankInformationForm
                            setAccountNumber={setAccountNumber}
                            // setAccountNumberError={setAccountNumberError}
                            setRoutingNumber={setRoutingNumber}
                            // setRoutingNumberError={setRoutingNumberError}
                            ref={bankInfoRef}
                        />
                        <p>{Message}</p>
                        <button id="updateButton" onClick={setBankAccount}>
                            Update
                        </button>
                    </div>
                </div>
                <Footer />
            </div>
        </>
    );
};
export default BankInfoPage;