import React from "react";
import "./AboutUsPage.css";
import TeamMember from "../../components/TeamMember/TeamMember";
import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";

export default function AboutUsPage() {
  const isLoggedIn = true;
  return (
    <>
      <div className="root">
        <Navbar isLoggedIn={isLoggedIn} />
        <h1> Meet Our Team</h1>
        <div className="team-members">
          <TeamMember
            className="team-member"
            imgName="taoufik"
            name="Taoufik Laaroussi"
            role="Project Manager"
            quote="I love Paris!"
          />
          <TeamMember
            className="team-member"
            imgName="kavi"
            name="Kavi Chapadia"
            role="Frontend Artist"
            quote="I love dogs!"
          />
          <TeamMember
            className="team-member"
            imgName="ahmed"
            name="Ahmed Elshetany"
            role="Frontend Artist"
            quote="I hate dogs!"
          />
          <TeamMember
            className="team-member"
            imgName="hussein"
            name="Hussein Noureddine"
            role="Frontend Artist"
            quote="I am hungry!"
          />
          <TeamMember
            className="team-member"
            imgName="chris"
            name="Christopher Foreman"
            role="Database Specialist"
            quote="live fast and eat ass"
          />
          <TeamMember
            className="team-member"
            imgName="steven"
            name="Steven Jimenez Mora"
            role="Backend Mechanic"
            quote="Going to space!"
          />
        </div>
        <Footer />
      </div>
    </>
  );
}
