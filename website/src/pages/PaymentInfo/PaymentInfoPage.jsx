import React from "react";
import "./PaymentInfoPage.css";

import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";
import CreditCardForm from "../../components/CreditCardForm/CreditCardForm";

const PaymentInfoPage = () => {
    return (
        <>
            <div className="content">
                <Navbar />
                <div className="content">
                    <div className="wrapper">
                        <h1>Payment Info</h1>
                    </div>
                    {/* <CreditCardForm
                    /> */}
                </div>
                <Footer />
            </div>
        </>
    );
};
export default PaymentInfoPage;