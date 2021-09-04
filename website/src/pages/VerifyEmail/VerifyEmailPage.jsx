import React from "react";
import { Link } from "react-router-dom";

const VerifyEmailPage = () => {
  return (
    <div
      className="content"
      style={{
        width: "100%",
        backgroundColor: "#001845",
        color: "white",
      }}
    >
      <h1>Email Verified</h1>
      <p
        style={{
          textAlign: "center",
          color: "white",
          backgroundColor: "whitesmoke",
        }}
      >
        <Link to="/login">Go Back to Login</Link>
      </p>
    </div>
  );
};

export default VerifyEmailPage;
