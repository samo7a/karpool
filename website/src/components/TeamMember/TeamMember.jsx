import React from "react";
import "./TeamMember.css";
const TeamMember = (props) => {
  return (
    <div className="team-member">
      <img
        className="avatar"
        src={require(`../../assets/${props.imgName}.jpg`).default}
        alt="team member avatar"
        width="200px"
        height="200px"
      />
      <h1>{props.name}</h1>
      <h1>{props.role}</h1>
      <p>
        <quote>{props.quote}</quote>
      </p>
    </div>
  );
};

export default TeamMember;
