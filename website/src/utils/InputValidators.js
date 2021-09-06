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
