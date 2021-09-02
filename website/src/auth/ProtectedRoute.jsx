import React from "react";
import { Route, Redirect } from "react-router-dom";
const ProtectedRoute = ({ isAuthed, isLoading, ...props }) => {
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
  }
  return <Route {...props} />;
};
 
export default ProtectedRoute;
