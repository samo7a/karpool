import React, { useState, useRef, useEffect } from "react";
import "./CarInfoPage.css";

import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";
import CarInformationForm from "../../components/CarInformationForm/CarInformationForm";

const CarInfoPage = () => {
    const [carBrand, setCarBrand] = useState("");
    const [carModel, setCarModel] = useState("");
    const [yearOfMan, setYearOfMan] = useState(0);
    const [carColor, setCarColor] = useState("");
    const [colorHex, setColorHex] = useState("");
    const [licensePlate, setLicensePlate] = useState("");
    const [driverLicense, setDriverLicense] = useState("");
    const [licenseExpDate, setLicenseExpDate] = useState("");
    const carInfoRef = useRef();

    return (
        <>
            <div className="content">
                <Navbar />
                <h1>Update Car Info</h1>
                <div className="content">
                    <div>
                        <div id="car-info">
                            <CarInformationForm
                                setCarBrand={setCarBrand}
                                setCarModel={setCarModel}
                                setYearOfMan={setYearOfMan}
                                setCarColor={setCarColor}
                                setColorHex={setColorHex}
                                setLicensePlate={setLicensePlate}
                                setDriverLicense={setDriverLicense}
                                setLicenseExpDate={setLicenseExpDate}
                                ref={carInfoRef}
                            />
                            <button id="cancelButton" /*onClick={}*/>
                                Cancel
                            </button>
                            <button id="updateButton" /*onClick={}*/>
                                Update
                            </button>
                        </div>
                    </div>
                </div>
                <Footer />
            </div>
        </>
    );
};
export default CarInfoPage;