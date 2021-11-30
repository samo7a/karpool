import React, { useState, useRef, useEffect } from "react";
import "./CarInfoPage.css";

import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";
import CarInformationForm from "../../components/CarInformationForm/CarInformationForm";
import firebase from "firebase";

const CarInfoPage = () => {
    const [carBrand, setCarBrand] = useState("");
    const [carModel, setCarModel] = useState("");
    const [yearOfMan, setYearOfMan] = useState(0);
    const [carColor, setCarColor] = useState("");
    const [colorHex, setColorHex] = useState("");
    const [licensePlate, setLicensePlate] = useState("");
    const [driverLicense, setDriverLicense] = useState("");
    const [licenseExpDate, setLicenseExpDate] = useState("");
    const [Message, setMessage] = useState("");
    const carInfoRef = useRef();

    useEffect(async () => {
        const result = await firebase.functions().httpsCallable('account-getVehicle')({});
        const { id, vehicle } = result.data;
        setCarBrand(vehicle.make);
        setCarColor(vehicle.color);
        setYearOfMan(vehicle.year);
        setLicensePlate(vehicle.licensePlateNum);
        // console.log(vehicle.make);
        // console.log(vehicle.color);
        // console.log(vehicle.year);
        // console.log(vehicle.licensePlateNum);
        // console.log(result);
    }, []);

    async function setCarInfo() {
        setMessage("");
        await firebase.functions().httpsCallable('account-updateVehicle')({
            make: carBrand,
            color: carColor,
            year: yearOfMan,
            licensePlateNum: licensePlate
        }).then(() => {
            setMessage("Car Info Successfully Updated!");
        }).catch(() => {
            setMessage("Car Info Not Updated!");
        });
    };

    return (
        <>
            <div className="content">
                <Navbar />
                <h1>Update Car Info</h1>
                {/* <h4><u>Current Values</u></h4> */}
                <table>
                    <tr>
                        <th>Car Brand</th>
                        <th>Car Color</th>
                        <th>Year of Manufacture</th>
                        <th>License Plate Number</th>
                    </tr>
                    <tr>
                        <td>{carBrand}</td>
                        <td>{carColor}</td>
                        <td>{yearOfMan}</td>
                        <td>{licensePlate}</td>
                    </tr>
                </table>
                <div id="car-info">
                    <CarInformationForm
                        showDriverLicense={false}
                        brand={carBrand}
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
                    <p>{Message}</p>
                    <button id="updateButton" onClick={setCarInfo}>
                        Update
                    </button>
                </div>

                <Footer />
            </div>
        </>
    );
};
export default CarInfoPage;