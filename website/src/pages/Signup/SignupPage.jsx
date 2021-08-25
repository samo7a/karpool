import React, { useState, useRef, useEffect } from "react";
import "./SignupPage.css";
import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";
import CreditCardForm from "../../components/CreditCardForm/CreditCardForm";
import BankInformationForm from "../../components/BankInformationForm/BankInformationForm";
import CarInformationForm from "../../components/CarInformationForm/CarInformationForm";
import CarInsuranceForm from "../../components/CarInsuranceForm/CarInsuranceForm";
import vid from "../../assets/promo.mp4";
import pic from "../../assets/ahmed.jpg";
import {
  checkFirstName,
  checkLastName,
  checkEmail,
  checkPhoneNumber,
  checkAge,
  checkPassword,
  checkConfirmPassword,
  checkGender,
} from "../../utils/InputValidators";
import { Elements } from "@stripe/react-stripe-js";
import { loadStripe } from "@stripe/stripe-js";
const stripePromise = loadStripe(
  "pk_test_51JR83uJIU8d9wquzsDhMJrc9nMGIAUGbDzJc7YP6Cngaz0bRFyLsrFd3P4M83TXdkXEijMSY3BfAOZk4OuiUBPC300QLOU9GVg"
);
const SignupPage = () => {
  const [photo, setPhoto] = useState(null);
  const [preview, setPreview] = useState();
  const photoRef = useRef();
  const [photoError, setPhotoError] = useState("");
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
  const [gender, setGender] = useState("");
  const [genderError, setGenderError] = useState("");
  const [password, setPassword] = useState("");
  const [passwordError, setPasswordError] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [confirmPasswordError, setConfirmPasswordError] = useState("");
  const [isDriver, setIsDriver] = useState(false);
  const [accountNumber, setAccountNumber] = useState("");
  const [accountNumberError, setAccountNumberError] = useState("");
  const [routingNumber, setRoutingNumber] = useState("");
  const [routingNumberError, setRoutingNumberError] = useState("");
  const [registerError, setRegisterError] = useState("");

  useEffect(() => {
    if (photo) {
      console.log(photo);
      const fileReader = new FileReader();
      fileReader.onloadend = () => {
        setPreview(fileReader.result);
      };
      fileReader.readAsDataURL(photo);
    } else setPreview(pic);
  }, [photo]);
  useEffect(() => {
    var day = new Date();
    var dd = String(day.getDate()).padStart(2, "0");
    var mm = String(day.getMonth() + 1).padStart(2, "0");
    var yyyy = day.getFullYear();
    var day2 = yyyy + "-" + mm + "-" + dd;
    setToday(day2);
  }, []);
  const handleFileChange = (event) => {
    const file = event.target.files[0];
    if (file && file.type.substr(0, 5) === "image") setPhoto(file);
    else setPhoto(null);
  };
  const handleFileUpload = async () => {
    const fd = new FormData();
    fd.append("image", photo, photo.name);
    //axios http post request to the endpoint when created. (MAX)
    //upload photo to the database
    //return the url of the uploaded file
  };

  const register = () => {
    //TODO: add functionality to regsiter button;
    console.log("register");
  };
  return (
    <div className="content">
      <Navbar loggedIn="false" />
      <div className="wrapper">
        <div className="left">
          <h1>Welcome to karpool!</h1>
          <form>
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
              <>
                <h2>Sign-up as a Rider!</h2>
                <Elements stripe={stripePromise}>
                  <CreditCardForm
                    firstName={firstName}
                    setFirstNameError={setFirstNameError}
                    lastName={lastName}
                    setLastNameError={setLastNameError}
                    email={email}
                    setEmailError={setEmailError}
                    phone={phone}
                    setPhoneError={setPhoneError}
                    dateOfBirth={dateOfBirth}
                    setDateOfBirthError={setDateOfBirthError}
                    gender={gender}
                    setGenderError={setGenderError}
                    password={password}
                    setPasswordError={setPasswordError}
                    confirmPassword={confirmPassword}
                    setConfirmPasswordError={setConfirmPasswordError}
                    isDriver={isDriver}
                    handleFileUpload={handleFileUpload}
                  />
                </Elements>
              </>
            ) : (
              <>
                <h2>Sign-up as a Driver!</h2>
                <BankInformationForm
                  accountNumber={accountNumber}
                  accountNumberError={accountNumberError}
                  setAccountNumber={setAccountNumber}
                  setAccountNumberError={setAccountNumberError}
                  routingNumber={routingNumber}
                  routingNumberError={routingNumberError}
                  setRoutingNumber={setRoutingNumber}
                  setRoutingNumberError={setRoutingNumberError}
                />
                <CarInformationForm />
                <CarInsuranceForm />
                <button id="primaryButton" onClick={register}>
                  Register
                </button>
                <p className="error">{registerError}</p>
                {/* for the car manufacture year, make it 15 years old */}
              </>
            )}
          </form>
        </div>
        <div className="right">
          <video width="75%" loop autoPlay muted>
            <source src={vid} type="video/mp4" />
          </video>
          <span> source: </span>
          <a href="https://www.vecteezy.com/video/2905810-cheerful-woman-spread-arms-on-car-rooftop-under-bright-sky-at-mountain-with-nature-background-during-road-trip-on-vacation">
            https://www.vecteezy.com
          </a>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default SignupPage;
