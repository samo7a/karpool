import React, { useState, useRef, useEffect } from "react";
import "./BankInfoPage.css";

import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";
import BankInformationForm from "../../components/BankInformationForm/BankInformationForm";

const BankInfoPage = () => {
    const [accountNumber, setAccountNumber] = useState("");
    const [routingNumber, setRoutingNumber] = useState("");
    const bankInfoRef = useRef();
    return (
        <>
            <div className="content">
                <Navbar />
                <div className="content">
                    <div className="wrapper">
                        <h1>Update Bank Info</h1>
                    </div>
                    <BankInformationForm
                        setAccountNumber={setAccountNumber}
                        // setAccountNumberError={setAccountNumberError}
                        setRoutingNumber={setRoutingNumber}
                        // setRoutingNumberError={setRoutingNumberError}
                        ref={bankInfoRef}
                    />
                    <button id="cancelButton" /*onClick={}*/>
                        Cancel
                    </button>
                    <button id="updateButton" /*onClick={}*/>
                        Update
                    </button>
                </div>
                <Footer />
            </div>
        </>
    );
};
export default BankInfoPage;