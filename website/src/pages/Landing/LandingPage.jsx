import React from "react";
import "./LandingPage.css";
import Navbar from "../../components/Navbar/Navbar";
import Footer from "../../components/Footer/Footer";
import vid from "../../assets/promo.mp4";
import {
  checkFirstName,
  checkLastName,
  checkEmail,
  checkPhoneNumber,
  checkPassword,
} from "../../utils/InputValidators";

const LandingPage = () => {
  let isLoggedIn = false;
  let json = checkFirstName("123");
  console.log("checkFirstName : " + JSON.stringify(json));
  json = checkLastName("pooi");
  console.log("checkLastName : " + JSON.stringify(json));
  json = checkEmail("aelsssh@fiu.edu");
  console.log("checkEmail : " + JSON.stringify(json));
  json = checkPhoneNumber("000");
  console.log("checkPhone : " + JSON.stringify(json));
  json = checkPassword("@Hmed1994");
  console.log("checkPassword : " + JSON.stringify(json));
  json = checkPassword("1111");
  console.log("checkPassword : " + JSON.stringify(json));

  return (
    <>
      <div className="content">
        <Navbar isLoggedIn={isLoggedIn} />
        <div className="wrapper">
          <div className="left">
            <article className="post">
              <h1>Share a Ride, Save The Planet!</h1>
              <p className="para">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec
                porta nunc at nisi laoreet, eget dapibus velit semper. Vivamus
                id hendrerit mi. Cras odio urna, blandit a odio vel, dapibus
                varius odio. Donec elit lacus, mollis ac sem non, luctus
                sollicitudin velit. Cras tincidunt tellus lectus, a consequat
                nulla venenatis sed. Sed sed quam a erat lobortis sollicitudin
                porttitor ullamcorper ex. Fusce accumsan nunc ut justo interdum
                tristique in at nisl. Morbi mattis pulvinar rhoncus. Mauris quam
                risus, pulvinar et urna et, convallis accumsan nisl. Praesent
                nec lectus vel velit lobortis lobortis. Etiam sollicitudin,
                sapien eget porta euismod, elit massa egestas est, id blandit mi
                ligula eu neque. Nulla interdum nibh nisi, non mollis mi luctus
                ac.
              </p>
            </article>
          </div>

          <div className="right">
            <video width="75%" loop autoPlay muted>
              <source src={vid} type="video/mp4" />
            </video>
            <span> source: </span>
            <a href="https://www.vecteezy.com/video/2905810-cheerful-woman-spread-arms-on-car-rooftop-under-bright-sky-at-mountain-with-nature-background-during-road-trip-on-vacation">
              https://www.vecteezy.com
            </a>
          </div>
        </div>
        <Footer />
      </div>
    </>
  );
};

export default LandingPage;
