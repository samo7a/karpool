import React from "react";
import { Route, Redirect } from "react-router-dom";
const ProtectedHome = ({ isAuthed, isLoading, ...props }) => {
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
    //props could be driver or rider
    var path = window.location.pathname;
    const role = localStorage.getItem("role");
    if (
      (path === "/driver-home" && role === "driver") ||
      (path === "/rider-home" && role === "rider")
    )
      return <Route {...props} />;
    // if (role === "driver" || role === "rider")
    else if (role === "driver") return <Redirect to="/driver-home" />;
    else if (role === "rider") return <Redirect to="/rider-home" />;
    else return <Redirect to="/" />;
  }
};

export default ProtectedHome;
