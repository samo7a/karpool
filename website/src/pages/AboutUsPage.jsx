import React from "react";
import "./AboutUsPage.css";
import TeamMember from "../components/TeamMember";
import Navbar from "../components/Navbar";
import Footer from "../components/Footer";

export default function AboutUsPage() {
  const isLoggedIn = true;
  return (
    <div>
      <Navbar isLoggedIn={isLoggedIn} />
      <h1> Meet Our Team</h1>
      <TeamMember />
      <TeamMember />
      <TeamMember />
      <TeamMember />
      <TeamMember />
      <TeamMember />
      <Footer />
    </div>
  );
}
