import React, { useState, useRef, useEffect } from "react";
import "./DriverAccountPage.css";
import { getCurrentUser } from '../../auth/getCurrentUser';
import { updateEmail } from "../../auth/updateEmail";
import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";
import { useAlert } from "react-alert";
import firebase from "firebase";
import { signOut } from "../../auth/signout";
import {
    checkEmail,
    checkPhoneNumber
} from "../../utils/InputValidators";

import pic from "../../assets/ahmed.jpg";

const DriverAccountPage = () => {
    //text input variables
    const [editable, setEditable] = useState(false);
    const [email, setEmail] = useState("");
    const [emailError, setEmailError] = useState("");
    const [originalEmail, setOriginalEmail] = useState("");
    const [resetError, setResetError] = useState("");
    const [phone, setPhone] = useState("");
    const [originalPhone, setOriginalPhone] = useState("");
    const [phoneError, setPhoneError] = useState("")
    const [password, setPassword] = useState("")
    const alert = useAlert();
    // const [password, setPassword] = useState("");
    // const [passwordError, setPasswordError] = useState("");
    // const [confirmPassword, setConfirmPassword] = useState("");
    // const [confirmPasswordError, setConfirmPasswordError] = useState("");

    // photo vars
    const [photo, setPhoto] = useState(null);
    const [preview, setPreview] = useState();
    const photoRef = useRef();
    const [photoError, setPhotoError] = useState("");

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
    useEffect(() => {
        const getUserInfo = async () => {
            const getDriverInfo = firebase.functions().httpsCallable('account-getUser');
            const data = {
                uid: getCurrentUser().uid,
                driver: true
            }
            const result = await getDriverInfo(data);
            console.log(result.data)
            const user = result.data;
            setPreview(user.profileURL);
            setPhone(user.phone)
            setEmail(getCurrentUser().email)
            setOriginalEmail(getCurrentUser().email)
            setOriginalPhone(user.phone)
            // const obj = { uid: user, driver: false }
        }
        getUserInfo();

    }, [])

    const handleFileChange = async (event) => {
        const file = event.target.files[0];
        if (file === undefined) {
            setPhoto(null);
            //setPreview(pic);
            setPhotoError("Please pick a profile picture");
            return;
        }
        if (file && file.type.substr(0, 5) === "image") {
            setPhoto(file);
            setPhotoError("");
            const base64 = await toBase64(file).catch((e) => Error(e));
            if (base64 instanceof Error) {
                setPhotoError(base64.message);
                console.log("Error: ", base64.message);
                // setIsLoading(false);
                return;
            }
            console.log("base64", base64)
            const updatePhoto = firebase.functions().httpsCallable("account-editUserProfile");
            const obj = {
                pic: base64
            }
            try {
                await updatePhoto(obj);

            } catch (e) {
                console.log(e)
            }

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

    const update = async () => {
        const update = firebase.functions().httpsCallable("account-editUserProfile");
        const obj = {
            phoneNum: phone,
        }
        try {
            await update(obj)
            setEditable(false)
        } catch (e) {
            console.log(e)
        }
    }
    const updateE = async () => {
        try {
            await updateEmail(originalEmail, password, email)
            console.log("updated email");
            await signOut();
            console.log("signed out");
        } catch (e) {
            console.log(e)
        }
    }

    const cancel = () => {
        setEmail(originalEmail)
        setPhone(originalPhone)
        setEditable(!editable)
    }
    const edit = () => {
        setEditable(!editable)
    }

    const resetPassword = async (event) => {
        event.preventDefault();
        setResetError("");
        try {
            const res = await firebase.auth().sendPasswordResetEmail(email);
            console.log(res);
            alert.success("Email has been sent!");
        } catch (e) {
            setResetError(e.message);
        }
    };

    return (
        <>
            <div className="content">
                <Navbar />
                <div className="content">
                    <div className="wrapper">
                        <h1>Account Management</h1>
                    </div>
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
                                    //value="Upload Profile Picture"
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
                            <label>Email Address</label>
                            <input
                                disabled={!editable}
                                value={email}
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
                        {editable ?
                            <div className="i">
                                <label>Password</label>
                                <input
                                    type="password"
                                    placeholder="Password"
                                    autoComplete="on"
                                    onChange={(event) => {
                                        setPassword(event.target.value);
                                    }}
                                    maxLength="50"
                                />
                            </div> : <></>
                        }

                        <p className="error">{emailError}</p>
                        <div className="i">
                            <label>Phone Number</label>
                            <input
                                disabled={!editable}
                                value={phone}
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
                    </form>
                    {editable ?
                        (<>
                            <button id="cancelButton" onClick={cancel}>
                                Cancel
                            </button>
                            <button id="updateButton"
                                onClick={update}>
                                Update Phone
                            </button>
                            <button id="updateButton"
                                onClick={updateE}>
                                Update Email
                            </button>
                        </>)
                        :
                        (<button id="cancelButton" onClick={edit}>
                            Edit
                        </button>)
                    }

                    <h1>Reset Password?</h1>
                    <form>
                        <button id="resetButton" onClick={resetPassword}>
                            Send Password Reset Email
                        </button>
                        <p className="error">{resetError}</p>
                    </form>
                </div>
                <Footer />
            </div>
        </>
    );
};
export default DriverAccountPage;
