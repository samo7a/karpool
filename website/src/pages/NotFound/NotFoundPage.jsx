import React from "react";
import { Link } from "react-router-dom";

const NotFoundPage = () => {
  return (
    <div
      className="content"
      style={{
        width: "100%",
        backgroundColor: "#001845",
        color: "white",
      }}
    >
      <h1>404</h1>
      <h2>Page Not Found</h2>
      <p
        style={{
          textAlign: "center",
          color: "white",
          backgroundColor: "whitesmoke",
        }}
      >
        <Link to="/">Go to Home </Link>
      </p>
    </div>
  );
};
export default NotFoundPage;
