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
      <h2>{props.name}</h2>
      <h4>{props.role}</h4>
      <p>
        <q>{props.quote}</q>
      </p>
    </div>
  );
};

export default TeamMember;
