export function checkFirstName(name) {
  var nameREGEX = /^[A-Za-z-,\s']+$/;
  if (name.length <= 1)
    return {
      valid: false,
      msg: "First name should be at least 2 characters long!",
    };

  if (!nameREGEX.test(name))
    return {
      valid: false,
      msg: "Please enter a valid name!",
    };

  if (name.length > 50)
    return {
      valid: false,
      msg: "First Name should not exceed 50 characters!",
    };

  return {
    valid: true,
    msg: "",
  };
}

export function checkLastName(name) {
  var nameREGEX = /^[A-Za-z-,\s']+$/;
  if (name.length <= 1)
    return {
      valid: false,
      msg: "First name should be at least 2 characters long!",
    };

  if (!nameREGEX.test(name))
    return {
      valid: false,
      msg: "Please enter a valid name!",
    };

  if (name.length > 50)
    return {
      valid: false,
      msg: "Last Name should not exceed 50 characters!",
    };

  return {
    valid: true,
    msg: "",
  };
}

export function checkEmail(email) {
  var emailREGEX = /^[^\s@]+@[^\s@\d]+\.[^\s@\d]+$/;
  if (email.length > 50)
    return {
      valid: false,
      msg: "Email is too long! Email should not exceed 50 characters!",
    };

  if (email.length === 0)
    return {
      valid: false,
      msg: "Email address field is required!",
    };

  if (!emailREGEX.test(email))
    return {
      valid: false,
      msg: "Please enter your email address in this format: yourname@example.com",
    };

  return {
    valid: true,
    msg: "",
  };
}

export function checkPhoneNumber(phoneNumber) {
  if (phoneNumber.length === 0)
    return {
      valid: false,
      msg: "Phone Number field is required!",
    };

  if (phoneNumber.length !== 10)
    return {
      valid: false,
      msg: "Please enter a valid phone number!",
    };

  var i;
  for (i = 0; i < phoneNumber.length; i++)
    if (phoneNumber.charAt(i) < "0" || phoneNumber.charAt(i) > "9")
      return {
        valid: false,
        msg: "Please enter a valid phone number!",
      };

  return {
    valid: true,
    msg: "",
  };
}

export function checkPassword(password) {
  var passwordREGEX = /^(?=.*[0-9])(?=.*[a-zA-Z])(?=\S+$).{6,50}$/;
  if (password.length === 0)
    return {
      valid: false,
      msg: "Password is required!",
    };

  if (!passwordREGEX.test(password))
    return {
      valid: false,
      msg: "Your password must be at least 6 characters long, contain at least one number, and one letter.Password should not exceed 50 characters!",
    };

  return {
    valid: true,
    msg: "",
  };
}

export function checkConfirmPassword(confirmPassword, password) {
  if (confirmPassword !== password)
    return {
      valid: false,
      msg: "The two passwords are not matched!",
    };

  return {
    valid: true,
    msg: "",
  };
}

export function checkAge(dob) {
  if (dob !== "") {
    var today = new Date();
    var birthDate = new Date(dob);
    var age = today.getFullYear() - birthDate.getFullYear();
    var m = today.getMonth() - birthDate.getMonth();
    var da = today.getDate() - birthDate.getDate();
    if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) age--;

    if (m < 0) m += 12;

    if (da < 0) da += 30;

    if (age < 18 || age > 100)
      return {
        valid: false,
        age: age,
        msg: "You should be 18 years old or older!",
      };
    else return { valid: true, msg: "" };
  } else
    return {
      valid: false,
      msg: "Please provide your date of birth",
    };
}
export function checkCarAge(yearOfMan) {
  var day = new Date();
  var thisYear = day.getFullYear();
  var age = thisYear - yearOfMan;

  if (age > 15)
    return {
      valid: false,
      age: age,
      msg: "The car should not be more than 15 years old!",
    };
  if (age < 0)
    return {
      valid: false,
      age: age,
      msg: "Please enter a valid date!",
    };
  else return { valid: true, msg: "" };
}
export function checkGender(gender) {
  if (gender === "gender")
    return {
      valid: false,
      msg: "Please Choose a gender",
    };
  else
    return {
      valid: true,
      msg: "",
    };
}
export function checkRiderSignup(
  firstName,
  lastName,
  email,
  phone,
  dob,
  gender,
  password,
  confirmPassword,
  isDriver
) {
  return (
    checkFirstName(firstName).valid &&
    checkLastName(lastName).valid &&
    checkEmail(email).valid &&
    checkPhoneNumber(phone).valid &&
    checkAge(dob).valid &&
    checkGender(gender).valid &&
    checkPassword(password).valid &&
    checkConfirmPassword(confirmPassword, password).valid &&
    !isDriver
  );
}
export function checkDriverSignUp(
  firstName,
  lastName,
  email,
  phone,
  dob,
  gender,
  password,
  confirmPassword,
  isDriver
) {
  return (
    checkFirstName(firstName).valid &&
    checkLastName(lastName).valid &&
    checkEmail(email).valid &&
    checkPhoneNumber(phone).valid &&
    checkAge(dob).valid &&
    checkGender(gender).valid &&
    checkPassword(password).valid &&
    checkConfirmPassword(confirmPassword, password).valid &&
    isDriver
  );
}
export function checkLicense(plate) {
  var plateREGEX = /^[0-9a-zA-Z]{6}$/;
  if (plate.length !== 6)
    return {
      valid: false,
      msg: "Please enter a valid license plate number!",
    };

  if (!plateREGEX.test(plate))
    return {
      valid: false,
      msg: "Please enter a valid license plate number!",
    };

  return {
    valid: true,
    msg: "",
  };
}

export function checkRoutingNumber(routingNumber) {
  if (routingNumber.length === 0)
    return {
      valid: false,
      msg: "Routing number field is required!",
    };

  if (routingNumber.length !== 9)
    return {
      valid: false,
      msg: "Please enter a valid routing number!",
    };

  var i;
  for (i = 0; i < routingNumber.length; i++)
    if (routingNumber.charAt(i) < "0" || routingNumber.charAt(i) > "9")
      return {
        valid: false,
        msg: "Please enter a valid routing number!",
      };

  return {
    valid: true,
    msg: "",
  };
}

export function checkAccountNumber(accountNumber) {
  if (accountNumber.length === 0)
    return {
      valid: false,
      msg: "Account number field is required!",
    };

  if (accountNumber.length < 9 || accountNumber.length > 12)
    return {
      valid: false,
      msg: "Please enter a valid account number!",
    };

  var i;
  for (i = 0; i < accountNumber.length; i++)
    if (accountNumber.charAt(i) < "0" || accountNumber.charAt(i) > "9")
      return {
        valid: false,
        msg: "Please enter a valid account number!",
      };

  return {
    valid: true,
    msg: "",
  };
}

export function checkBrand(brand) {
  if (brand.length === 0)
    return {
      valid: false,
      msg: "Please choose a car brand!",
    };
  else
    return {
      valid: true,
      msg: "",
    };
}
export function checkColor(color) {
  if (color.length === 0)
    return {
      valid: false,
      msg: "Please choose a car brand!",
    };
  else
    return {
      valid: true,
      msg: "",
    };
}
export function checkDriverLicense(stateCode, licenseNumber) {
  var oneToSevenNumeric = /^[0-9]{1,7}$/;
  var oneAlpha = /(.*[A-Za-z]){1}/;
  var oneAlphaPlusSeven = /^.[0-9]{7}$/;
  var twoAlpha = /(.*[A-Za-z]){2}/;
  var alphaPlusSixNumeric = /(.*[0-9]){6}$/;
  var threeToFiveNumeric = /(.*[0-9]){3,5}$/;
  var fiveToNineNumeric = /(.*[0-9]){5,9}/;
  var sixNumeric = /^[0-9]{6}$/;
  var sevenNumeric = /^[0-9]{7}$/;
  var sevenToNineNumeric = /^[0-9]{7,9}$/;
  var eightAreNumbers = /(.*[0-9]){8}/;
  var nineNumeric = /^[0-9]{9}$/;
  var nineAlphaChars = /^[A-Za-z0-9]{9}$/;
  var tenNumeric = /^[0-9]{10}$/;
  var elevenNumeric = /^.[0-9]{11}$/;
  var twelveNumeric = /^.[0-9]{12}$/;
  var hPlusEight = /([H][0-9]{8})$/;
  var sevenPlusX = /([H][0-9]{7}X)$/;

  if (stateCode === undefined || licenseNumber === undefined) {
    return {
      valid: false,
      msg: "",
    };
  }

  if (stateCode === "AK") {
    return validateExpression(
      oneToSevenNumeric,
      licenseNumber,
      "Must be 1-7 numeric"
    );
  }
  if (stateCode === "AL") {
    return validateExpression(sevenNumeric, licenseNumber, "Must be 7 numeric");
  }
  if (stateCode === "AR" || stateCode === "MS") {
    return validateExpression(nineNumeric, licenseNumber, "Must be 9 numeric");
  }
  if (stateCode === "AZ") {
    if (nineNumeric.test(licenseNumber) === true) {
      return "";
    }
    if (oneAlpha.test(licenseNumber) && eightAreNumbers.test(licenseNumber)) {
      return "";
    }
    if (
      twoAlpha.test(licenseNumber) &&
      threeToFiveNumeric.test(licenseNumber) &&
      licenseNumber.length < 8
    ) {
      return "";
    }
    return "Must be 1 Alphabetic, 8 Numeric; or 2 Alphabetic, 3-6 Numeric; or 9 Numeric";
  }
  if (stateCode === "CA") {
    if (oneAlpha.test(licenseNumber) && oneAlphaPlusSeven.test(licenseNumber)) {
      return "";
    }
    return "Must be 1 alpha and 7 numeric";
  }
  if (stateCode === "CO" || stateCode === "CN" || stateCode === "CT") {
    return validateExpression(nineNumeric, licenseNumber, "Must be 9 numeric");
  }
  if (stateCode === "DC") {
    if (sevenNumeric.test(licenseNumber) || nineNumeric.test(licenseNumber)) {
      return "";
    }
    return "Must be 7 - 9 numeric";
  }
  if (stateCode === "DE") {
    if (oneToSevenNumeric.test(licenseNumber)) {
      return "";
    }
    return "Must be 1 - 7 numeric";
  }
  if (stateCode === "FL") {
    if (oneAlpha.test(licenseNumber) && twelveNumeric.test(licenseNumber)) {
      return { valid: true, msg: "" };
    }
    return { valid: false, msg: "Must be 1 alpha, 12 numeric" };
  }
  if (stateCode === "GA") {
    if (sevenToNineNumeric.test(licenseNumber)) {
      return "";
    }
    return "Must be 7 - 9 numeric";
  }
  if (stateCode === "HI") {
    if (nineNumeric.test(licenseNumber) || hPlusEight.test(licenseNumber)) {
      return "";
    }
    return "Must 'H' + 8 numeric; 9 numeric";
  }
  if (stateCode === "ID") {
    if (
      nineNumeric.test(licenseNumber) ||
      sixNumeric.test(licenseNumber) ||
      (twoAlpha.test(licenseNumber) && alphaPlusSixNumeric.test(licenseNumber))
    ) {
      return "";
    }
    return "Must 9 numbers or 6 numbers; or 2 char, 6 numbers ";
  }

  if (stateCode === "IL") {
    if (oneAlpha.test(licenseNumber) && elevenNumeric.test(licenseNumber)) {
      return "";
    }
    return "Must 1 character 11 numbers";
  }
  if (stateCode === "IN") {
    if (tenNumeric.test(licenseNumber) || nineNumeric.test(licenseNumber)) {
      return "";
    }
    return "Must be 9-10 numbers";
  }
  if (stateCode === "IA") {
    if (nineAlphaChars.test(licenseNumber) || nineNumeric.test(licenseNumber)) {
      return "";
    }
    return "Must be 9 alpha numbers";
  }
  if (stateCode === "KS" || stateCode === "KY") {
    if (
      nineNumeric.test(licenseNumber) ||
      (oneAlpha.test(licenseNumber) &&
        eightAreNumbers.test(licenseNumber) &&
        licenseNumber.length === 9)
    ) {
      return "";
    }
    return "Must be 1 alpha and 8 numeric";
  }
  if (stateCode === "LA") {
    if (nineNumeric.test(licenseNumber) === true) {
      return "";
    }
    return "Must be 9 numeric";
  }
  if (stateCode === "ME") {
    if (sevenNumeric.test(licenseNumber) || sevenPlusX.test(licenseNumber)) {
      return "";
    }
    return "Must be 7 numeric";
  }
  if (stateCode === "MD" || stateCode === "MI" || stateCode === "MN") {
    if (oneAlpha.test(licenseNumber) && twelveNumeric.test(licenseNumber)) {
      return "";
    }
    return "1 Alphabetic, 12 Numeric";
  }
  if (stateCode === "MA") {
    if (
      (oneAlpha.test(licenseNumber) &&
        eightAreNumbers.test(licenseNumber) &&
        licenseNumber.length === 9) ||
      nineNumeric.test(licenseNumber)
    ) {
      return "";
    }
    return "Must be 1 alpha, 8 numeric; 9 numeric";
  }

  if (stateCode === "MO") {
    if (
      (oneAlpha.test(licenseNumber) &&
        fiveToNineNumeric.test(licenseNumber) &&
        licenseNumber.length < 11) ||
      nineNumeric.test(licenseNumber)
    ) {
      return "";
    }
    return "1 alpha - 5-9 Numeric or 9 numeric";
  }
  return "";
}

function validateExpression(expression, value, error) {
  if (expression.test(value) === true) {
    return "";
  }
  return error;
}
