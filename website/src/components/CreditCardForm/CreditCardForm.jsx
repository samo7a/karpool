// import React, { useState } from "react";
// import "./CreditCardForm.css";
// import {
//     checkRiderSignup,
//     checkFirstName,
//     checkLastName,
//     checkEmail,
//     checkPhoneNumber,
//     checkAge,
//     checkGender,
//     checkPassword,
//     checkConfirmPassword,
// } from "../../utils/InputValidators";
// import { signup } from "../../auth/signup";
// import { signOut } from "../../auth/signout";
// import { getCurrentUser } from "../../auth/getCurrentUser";
// import firebase from "firebase";
// import stripeImg from "../../assets/stripe_secure.png";
// import { CardElement, useStripe, useElements } from "@stripe/react-stripe-js";
// const stripePromise = loadStripe(process.env.REACT_APP_PUBLIC_STRIPE_API_KEY);
// const CreditCardForm = (props) => {
//     const [creditCardError, setCreditCardError] = useState("");
//     const [registerError, setRegisterError] = useState("");
//     //const [uid, setUid] = useState("");

//     const stripe = useStripe();
//     const elements = useElements();
//     import { Elements } from "@stripe/react-stripe-js";
//     import { loadStripe } from "@stripe/stripe-js";
//     const firstName = props.firstName;
//     const lastName = props.lastName;
//     const email = props.email;
//     const phone = props.phone;
//     const dob = props.dateOfBirth;
//     const gender = props.gender;
//     const password = props.password;
//     const confirmPassword = props.confirmPassword;
//     const isDriver = props.isDriver;

//     const registerRider = async (event) => {
//         event.preventDefault();
//         props.setFirstNameError("");
//         props.setLastNameError("");
//         props.setEmailError("");
//         props.setPhoneError("");
//         props.setDateOfBirthError("");
//         props.setGenderError("");
//         props.setPasswordError("");
//         props.setConfirmPasswordError("");
//         setCreditCardError("");
//         setRegisterError("");

//         const isValid = checkRiderSignup(
//             firstName,
//             lastName,
//             email,
//             phone,
//             dob,
//             gender,
//             password,
//             confirmPassword,
//             isDriver
//         );

//         if (!isValid) {
//             setRegisterError(
//                 "Please fill all the required data or fix the format of the input!"
//             );
//             props.setFirstNameError(checkFirstName(firstName).msg);
//             props.setLastNameError(checkLastName(lastName).msg);
//             props.setEmailError(checkEmail(email).msg);
//             props.setPhoneError(checkPhoneNumber(phone).msg);
//             props.setDateOfBirthError(checkAge(dob).msg);
//             props.setGenderError(checkGender(gender).msg);
//             props.setPasswordError(checkPassword(password).msg);
//             props.setConfirmPasswordError(
//                 checkConfirmPassword(confirmPassword, password).msg
//             );
//             return;
//         } else setRegisterError("");

//         var id;

//         // const cardElement = elements.getElement(CardElement);
//         // const result = await stripe.confirmCardSetup('{{CLIENT_SECRET}}', {
//         //   payment_method: {
//         //     card: cardElement,
//         //     billing_details: {
//         //       name: 'Jenny Rosen',
//         //     },
//         //   }
//         // });

//         //   if (result.error) {
//         //     // Display result.error.message in your UI.
//         //   } else {
//         // //     // The setup has succeeded. Display a success message and send
//         // //     // result.setupIntent.payment_method to your server to save the
//         // //     // card to a Customer
//         // //   }
//         // // // };

//         // const { error, paymentMethod } = await stripe.createPaymentMethod({
//         //   type: "card",
//         //   card: cardElement,
//         // });
//         // if (error) {
//         //   setCreditCardError(error.message);
//         //   setRegisterError(
//         //     "Please fill all the required data or fix the format of the input!"
//         //   );
//         //   return;
//         // } else {
//         //   console.log("[PaymentMethod]", paymentMethod);

//         //   setCreditCardError("");
//         //   setRegisterError("");
//         // }
//         //return;

//         // // TODO: Check the logic here.
//         // try {
//         //   const user = await signup(email, password);
//         //   // const user = await signup("samo7a98@mail.com", "password1234");
//         //   id = user.user.uid;
//         // } catch (e) {
//         //   setRegisterError(e.message);
//         //   return;
//         // }

//         // TODO: add profilePicData: based64Image(),
//         const obj = {
//             firstName: firstName,
//             lastName: lastName,
//             email: email,
//             password: password,
//             phone: phone,
//             dob: dob,
//             gender: gender,
//             isDriver: isDriver,
//             profilePicData: "profile picture change it later",
//         };

//         //null means everything good.
//         //error if something went wrong

//         const register = firebase.functions().httpsCallable("account-registerUser");
//         try {
//             const result = await register(obj);
//             console.log("result", result); // should be null
//         } catch (e) {
//             console.log(e.message);
//         }
//         // direct the user to the login page.
//     };

//     return (
//         <>
//             <div id="credit-card-form">
//                 <h4>Credit Card Information</h4>
//                 <CardElement
//                     id="card-element"
//                     options={{
//                         style: {
//                             base: {
//                                 fontSize: "16px",
//                                 color: "#fff",
//                                 "::placeholder": {
//                                     color: "#87bbfd",
//                                 },
//                             },
//                             invalid: {
//                                 color: "red",
//                                 iconColor: "red",
//                             },
//                             complete: {
//                                 color: "green",
//                             },
//                         },
//                         hidePostalCode: true,
//                     }}
//                 />
//                 <p className="error">{creditCardError}</p>
//                 <img alt="Powered by stripe" src={stripeImg} id="stripe-img" />
//             </div>

//             <button id="primaryButton" onClick={registerRider}>
//                 Register
//             </button>
//             <p className="error">{registerError}</p>
//         </>
//     );
// };

// export default CreditCardForm;
// {
//     /* <h2>Sign-up as a Rider!</h2>
//                   <Elements stripe={stripePromise}>
//                     <CreditCardForm
//                       firstName={firstName}
//                       setFirstNameError={setFirstNameError}
//                       lastName={lastName}
//                       setLastNameError={setLastNameError}
//                       email={email}
//                       setEmailError={setEmailError}
//                       phone={phone}
//                       setPhoneError={setPhoneError}
//                       dateOfBirth={dateOfBirth}
//                       setDateOfBirthError={setDateOfBirthError}
//                       gender={gender}
//                       setGenderError={setGenderError}
//                       password={password}
//                       setPasswordError={setPasswordError}
//                       confirmPassword={confirmPassword}
//                       setConfirmPasswordError={setConfirmPasswordError}
//                       isDriver={isDriver}
//                       //handleFileUpload={handleFileUpload}
//                     />
//                   </Elements> */
// }