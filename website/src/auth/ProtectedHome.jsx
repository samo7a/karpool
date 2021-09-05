import React from "react";
import { Route, Redirect } from "react-router-dom";
const ProtectedHome = ({ isAuthed, isLoading }) => {
  if (isLoading) {
    return (
      <div
        style={{
          height: 90000,
          width: 90000,
          backgroundColor: "#001233",
        }}
      ></div>
    );
  }
  if (!isAuthed) {
    return <Redirect to="/" />;
  } else {
    // getProfile
    // return <Route exact path ="/rider-home" />
    // return <Route exact path="/driver-home" />;
  }
};

export default ProtectedHome;
