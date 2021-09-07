import React, { useState, useRef, useEffect } from "react";
import "./SignupPage.css";

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

import { signOut } from "../../auth/signout";
import firebase from "firebase";
import pic from "../../assets/ahmed.jpg";
import { useAlert } from "react-alert";

const SignupPage = () => {
  //text input variables
  const [firstName, setFirstName] = useState("");
  const [firstNameError, setFirstNameError] = useState("");
  const [lastName, setLastName] = useState("");
  const [lastNameError, setLastNameError] = useState("");
  const [email, setEmail] = useState("");
  const [emailError, setEmailError] = useState("");
  const [phone, setPhone] = useState("");
  const [phoneError, setPhoneError] = useState("");
  const [today, setToday] = useState("");
  const [dateOfBirth, setDateOfBirth] = useState("");
  const [dateOfBirthError, setDateOfBirthError] = useState("");
  const [gender, setGender] = useState("gender");
  const [genderError, setGenderError] = useState("");
  const [password, setPassword] = useState("");
  const [passwordError, setPasswordError] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [confirmPasswordError, setConfirmPasswordError] = useState("");
  const [isDriver, setIsDriver] = useState(false);
  const [accountNumber, setAccountNumber] = useState("");
  const [routingNumber, setRoutingNumber] = useState("");
  const [carBrand, setCarBrand] = useState("");
  const [carModel, setCarModel] = useState("");
  const [yearOfMan, setYearOfMan] = useState(0);
  const [carColor, setCarColor] = useState("");
  const [colorHex, setColorHex] = useState("");
  const [licensePlate, setLicensePlate] = useState("");
  const [driverLicense, setDriverLicense] = useState("");
  const [licenseExpDate, setLicenseExpDate] = useState("");
  const [insuranceProvider, setInsuranceProvider] = useState("");
  const [coverageType, setCoverageType] = useState("");
  const [coverageStartDate, setCoverageStartDate] = useState("");
  const [coverageEndDate, setCoverageEndDate] = useState("");
  const [registerError, setRegisterError] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const bankInfoRef = useRef();
  const carInfoRef = useRef();
  const carInsuranceRef = useRef();
  // photo vars
  const [photo, setPhoto] = useState(null);
  const [preview, setPreview] = useState();
  const photoRef = useRef();
  const [photoError, setPhotoError] = useState("");
  const alert = useAlert();
  useEffect(() => {
    if (photo) {
      // console.log(photo);
      const fileReader = new FileReader();
      fileReader.onloadend = () => {
        setPreview(fileReader.result);
      };
      fileReader.readAsDataURL(photo);
    } else setPreview(pic);
  }, [photo]);

  const handleFileChange = (event) => {
    const file = event.target.files[0];
    if (file === undefined) {
      setPhoto(null);
      //setPreview(pic);
      setPhotoError("Please pick a profile picture");
      return;
    }
    console.log(file);
    if (file && file.type.substr(0, 5) === "image") {
      setPhoto(file);
      setPhotoError("");
    } else {
      setPhoto(null);
      setPhotoError("Please pick a profile picture");
    }
  };
  const toBase64 = (file) =>
    new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = () => {
        let encoded = reader.result.toString().replace(/^data:(.*,)?/, "");
        if (encoded.length % 4 > 0) {
          encoded += "=".repeat(4 - (encoded.length % 4));
        }
        resolve(encoded);
      };
      // reader.readAsArrayBuffer(file);
      reader.onerror = (error) => reject(error);
    });

  useEffect(() => {
    var day = new Date();
    var dd = String(day.getDate()).padStart(2, "0");
    var mm = String(day.getMonth() + 1).padStart(2, "0");
    var yyyy = day.getFullYear();
    var day2 = yyyy + "-" + mm + "-" + dd;
    setToday(day2);
  }, []);
  useEffect(() => {
    signOut();
  }, []);
  const registerRider = async (event) => {
    event.preventDefault();
    setIsLoading(true);
    setFirstNameError("");
    setLastNameError("");
    setEmailError("");
    setPhoneError("");
    setDateOfBirthError("");
    setGenderError("");
    setPasswordError("");
    setConfirmPasswordError("");
    setPhotoError("");
    setRegisterError("");
    const validPhoto = photo !== null;
    if (!validPhoto) {
      setRegisterError(
        "Please fill all the required data or fix the format of the input!"
      );
      setPhotoError("Please pick a profile picture");
    }
    const isValid = checkRiderSignup(
      firstName,
      lastName,
      email,
      phone,
      dateOfBirth,
      gender,
      password,
      confirmPassword,
      isDriver
    );

    if (!isValid) {
      setRegisterError(
        "Please fill all the required data or fix the format of the input!"
      );
      setFirstNameError(checkFirstName(firstName).msg);
      setLastNameError(checkLastName(lastName).msg);
      setEmailError(checkEmail(email).msg);
      setPhoneError(checkPhoneNumber(phone).msg);
      setDateOfBirthError(checkAge(dateOfBirth).msg);
      setGenderError(checkGender(gender).msg);
      setPasswordError(checkPassword(password).msg);
      setConfirmPasswordError(
        checkConfirmPassword(confirmPassword, password).msg
      );
    }
    if (isValid && validPhoto) setRegisterError("");
    else {
      setIsLoading(false);
      return;
    }

    const base64 = await toBase64(photo).catch((e) => Error(e));
    if (base64 instanceof Error) {
      setPhotoError(base64.message);
      console.log("Error: ", base64.message);
      setIsLoading(false);
      return;
    }
    console.log("base64", photo);
    const obj = {
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phone: phone,
      dob: dateOfBirth,
      gender: gender,
      isDriver: isDriver,
      profilePicData: base64,
    };
    console.log("obj", obj);
    //null means everything good.
    //error if something went wrong

    const register = firebase.functions().httpsCallable("account-registerUser");
    try {
      const result = await register(obj);
      if (result === null) {
        alert.success("Signed Up!");
      }
      setIsLoading(false);
    } catch (e) {
      console.log(e.message);
      setRegisterError(e.message);
      setIsLoading(false);
    }
    // direct the user to the login page.
  };
  const registerDriver = async (event) => {
    event.preventDefault();
    setIsLoading(true);
    setFirstNameError("");
    setLastNameError("");
    setEmailError("");
    setPhoneError("");
    setDateOfBirthError("");
    setGenderError("");
    setPasswordError("");
    setConfirmPasswordError("");
    bankInfoRef.current.setBankError("");
    carInfoRef.current.setCarInfo("");
    carInsuranceRef.current.setInsuranceInfo("");
    setRegisterError("");
    const validPhoto = photo !== null;
    if (!validPhoto) {
      setRegisterError(
        "Please fill all the required data or fix the format of the input!"
      );
      setPhotoError("Please pick a profile picture");
    }
    const firstCheck = checkDriverSignUp(
      firstName,
      lastName,
      email,
      phone,
      dateOfBirth,
      gender,
      password,
      confirmPassword,
      isDriver
    );
    if (!firstCheck) {
      setRegisterError(
        "Please fill all the required data or fix the format of the input!"
      );
      setFirstNameError(checkFirstName(firstName).msg);
      setLastNameError(checkLastName(lastName).msg);
      setEmailError(checkEmail(email).msg);
      setPhoneError(checkPhoneNumber(phone).msg);
      setDateOfBirthError(checkAge(dateOfBirth).msg);
      setGenderError(checkGender(gender).msg);
      setPasswordError(checkPassword(password).msg);
      setConfirmPasswordError(
        checkConfirmPassword(confirmPassword, password).msg
      );
    }
    const secondCheck = bankInfoRef.current.checkBankInfo();
    if (!secondCheck) {
      setRegisterError(
        "Please fill all the required data or fix the format of the input!"
      );
      bankInfoRef.current.checkAccountNumber1();
      bankInfoRef.current.checkRoutingNumber1();
    }
    const thirdCheck = carInfoRef.current.checkCarInfo();
    if (!thirdCheck) {
      setRegisterError(
        "Please fill all the required data or fix the format of the input!"
      );
      carInfoRef.current.checkBrand1();
      carInfoRef.current.checkCarModel1();
      carInfoRef.current.checkColor1();
      carInfoRef.current.checkCarAge1();
      carInfoRef.current.checkLicense1();
      carInfoRef.current.checkDriverLicense();
      carInfoRef.current.checkDriverLicenseExpDate();
    }
    const forthCheck = carInsuranceRef.current.checkInsInfo();
    if (!forthCheck) {
      setRegisterError(
        "Please fill all the required data or fix the format of the input!"
      );
      carInsuranceRef.current.checkProvider1();
      carInsuranceRef.current.checkCoverageType1();
    }

    if (firstCheck && secondCheck && thirdCheck && forthCheck && validPhoto)
      setRegisterError("");
    else {
      setIsLoading(false);
      return;
    }

    const base64 = await toBase64(photo).catch((e) => Error(e));
    if (base64 instanceof Error) {
      setPhotoError(base64.message);
      console.log("Error: ", base64.message);
      setIsLoading(false);
      return;
    }
    console.log("base64", photo);
    const obj = {
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      dob: dateOfBirth,
      gender: gender,
      password: password,
      routingNum: routingNumber,
      accountNum: accountNumber,
      make: carBrand,
      carModel: carModel,
      year: yearOfMan,
      color: carColor,
      colorHex: colorHex,
      isDriver: isDriver,
      plateNum: licensePlate,
      provider: insuranceProvider,
      coverage: coverageType,
      startDate: coverageStartDate,
      endDate: coverageEndDate,
      licenseNum: driverLicense,
      licenseExpDate: licenseExpDate,
      profilePicData: base64,
    };
    console.log("obj", obj);
    //null means everything good.
    //error if something went wrong
    const register = firebase.functions().httpsCallable("account-registerUser");
    try {
      const result = await register(obj);
      if (result === null) {
        alert.success("Signed Up!");
      }
      setIsLoading(false);
    } catch (e) {
      setRegisterError(e.message);
      setIsLoading(false);
    }
    //direct the user to the login screen.
  };
  return (
    <div className="content">
      <Navbar />
      <div className="wrapper">
        <div className="left">
          <h1>Welcome to karpool!</h1>
          <form>
            <h1>Upload a profile picture</h1>
            <div className="img-wrap">
              {preview ? (
                <img
                  id="preview"
                  alt="profile-pic"
                  src={preview}
                  style={{ objectFit: "cover" }}
                  onClick={(event) => {
                    event.preventDefault();
                    photoRef.current.click();
                  }}
                />
              ) : (
                <input
                  id="img-uploader"
                  type="button"
                  name="button"
                  value="Upload Profile Picture"
                  onClick={(event) => {
                    event.preventDefault();
                    photoRef.current.click();
                  }}
                />
              )}
              <p
                onClick={(event) => {
                  event.preventDefault();
                  photoRef.current.click();
                }}
                className="img-text"
              >
                Pick Profile Picture
              </p>
            </div>
            <input
              style={{ display: "none" }}
              type="file"
              accept="image/*"
              onChange={handleFileChange}
              ref={photoRef}
            />
            <p className="error">{photoError}</p>
            <div className="i">
              <label>First Name</label>
              <input
                id="fname"
                type="text"
                placeholder="First Name"
                onChange={(event) => {
                  const obj = checkFirstName(event.target.value);
                  if (obj.valid === false) setFirstNameError(obj.msg);
                  else setFirstNameError("");
                  setFirstName(event.target.value);
                }}
                maxLength="50"
              />
            </div>
            <p className="error">{firstNameError}</p>
            <div className="i">
              <label>Last Name</label>
              <input
                type="text"
                placeholder="Last Name"
                onChange={(event) => {
                  const obj = checkLastName(event.target.value);
                  if (obj.valid === false) setLastNameError(obj.msg);
                  else setLastNameError("");
                  setLastName(event.target.value);
                }}
                maxLength="50"
              />
            </div>
            <p className="error">{lastNameError}</p>
            <div className="i">
              <label>Email Address</label>
              <input
                type="text"
                placeholder="Email Address"
                onChange={(event) => {
                  const obj = checkEmail(event.target.value);
                  if (obj.valid === false) setEmailError(obj.msg);
                  else setEmailError("");
                  setEmail(event.target.value);
                }}
                maxLength="50"
              />
            </div>
            <p className="error">{emailError}</p>
            <div className="i">
              <label>Phone Number</label>
              <input
                type="text"
                placeholder="Phone Number"
                onChange={(event) => {
                  const obj = checkPhoneNumber(event.target.value);
                  if (obj.valid === false) setPhoneError(obj.msg);
                  else setPhoneError("");
                  setPhone(event.target.value);
                }}
                maxLength="10"
              />
            </div>
            <p className="error">{phoneError}</p>
            <div className="i">
              <label>Date of birth</label>
              <input
                required
                type="date"
                max={today}
                onChange={(event) => {
                  const obj = checkAge(event.target.value);
                  if (obj.valid === false)
                    setDateOfBirthError(
                      obj.msg +
                        ` 
				  You are ${obj.age} years old!`
                    );
                  else setDateOfBirthError("");
                  setDateOfBirth(event.target.value);
                }}
              />
            </div>
            <p className="error">{dateOfBirthError}</p>
            <div className="i">
              <label>Gender</label>
              <div id="gender">
                <select
                  id="gender-dropdown"
                  value={gender}
                  onChange={(event) => {
                    const obj = checkGender(event.target.value);

                    if (obj.valid === false) setGenderError(obj.msg);
                    else setGenderError("");
                    setGender(event.target.value);
                  }}
                >
                  <option value="gender" name="gender">
                    Gender
                  </option>
                  <option value="male" name="male">
                    Male
                  </option>
                  <option value="female" name="female">
                    Female
                  </option>
                  <option value="other" name="other">
                    Other
                  </option>
                </select>
                <p className="error">{genderError}</p>
              </div>
            </div>
            <div className="i">
              <label>Password</label>
              <input
                type="password"
                placeholder="Password"
                autoComplete="on"
                onChange={(event) => {
                  const obj = checkPassword(event.target.value);
                  const obj2 = checkConfirmPassword(
                    confirmPassword,
                    event.target.value
                  );
                  if (obj.valid === false) setPasswordError(obj.msg);
                  else setPasswordError("");
                  if (obj2.valid === false) setConfirmPasswordError(obj2.msg);
                  else setConfirmPasswordError("");
                  setPassword(event.target.value);
                }}
                maxLength="50"
              />
            </div>
            <p className="error">{passwordError}</p>
            <div className="i">
              <label>Confirm the Password</label>
              <input
                type="password"
                autoComplete="on"
                placeholder="Confirm the password"
                onChange={(event) => {
                  const obj = checkConfirmPassword(
                    event.target.value,
                    password
                  );
                  const obj2 = checkPassword(password);
                  if (obj.valid === false) setConfirmPasswordError(obj.msg);
                  else setConfirmPasswordError("");
                  if (obj2.valid === false) setPasswordError(obj2.msg);
                  else setPasswordError("");
                  setConfirmPassword(event.target.value);
                }}
                maxLength="50"
              />
            </div>
            <p className="error">{confirmPasswordError}</p>
            <div id="radio">
              <label>Are you driving?</label>
              <label className="switch">
                <input
                  type="checkbox"
                  checked={isDriver}
                  onChange={(event) => {
                    setIsDriver(!isDriver);
                  }}
                />
                <span className="slider round"></span>
              </label>
            </div>
            {!isDriver ? (
              <></>
            ) : (
              <>
                <h2>Sign-up as a Driver!</h2>
                <BankInformationForm
                  setAccountNumber={setAccountNumber}
                  // setAccountNumberError={setAccountNumberError}
                  setRoutingNumber={setRoutingNumber}
                  // setRoutingNumberError={setRoutingNumberError}
                  ref={bankInfoRef}
                />
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
                <CarInsuranceForm
                  setInsuranceProvider={setInsuranceProvider}
                  setCoverageType={setCoverageType}
                  setCoverageStartDate={setCoverageStartDate}
                  setCoverageEndDate={setCoverageEndDate}
                  ref={carInsuranceRef}
                />
              </>
            )}
            <button
              id="primaryButton"
              onClick={isDriver ? registerDriver : registerRider}
              disabled={isLoading}
            >
              {isLoading && (
                <i
                  className="fa fa-refresh fa-spin"
                  style={{ marginRight: "5px" }}
                />
              )}
              {isLoading && <span>Signing up ...</span>}
              {!isLoading && <span>Register</span>}
            </button>
            <p className="error">{registerError}</p>
          </form>
        </div>
        <div className="right">
          <video width="75%" loop autoPlay muted>
            <source
              src="https://firebasestorage.googleapis.com/v0/b/karpool-1ea95.appspot.com/o/vids%2Fpromo.mp4?alt=media&token=01833b23-d0f6-44ed-be5b-33a8ad92ea85"
              type="video/mp4"
            />
          </video>
          <span> source: </span>
          <a href="https://www.vecteezy.com/video/2905810-cheerful-woman-spread-arms-on-car-rooftop-under-bright-sky-at-mountain-with-nature-background-during-road-trip-on-vacation">
            https://www.vecteezy.com
          </a>
          <article className="post">
            <h1>Share a Ride, Save The Planet!</h1>
            <p className="para">
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec
              porta nunc at nisi laoreet, eget dapibus velit semper. Vivamus id
              hendrerit mi. Cras odio urna, blandit a odio vel, dapibus varius
              odio. Donec elit lacus, mollis ac sem non, luctus sollicitudin
              velit. Cras tincidunt tellus lectus, a consequat nulla venenatis
              sed. Sed sed quam a erat lobortis sollicitudin porttitor
              ullamcorper ex. Fusce accumsan nunc ut justo interdum tristique in
              at nisl. Morbi mattis pulvinar rhoncus. Mauris quam risus,
              pulvinar et urna et, convallis accumsan nisl. Praesent nec lectus
              vel velit lobortis lobortis. Etiam sollicitudin, sapien eget porta
              euismod, elit massa egestas est, id blandit mi ligula eu neque.
              Nulla interdum nibh nisi, non mollis mi luctus ac.
            </p>
          </article>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default SignupPage;
