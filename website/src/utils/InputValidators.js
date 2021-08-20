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
  if (name.length < 1)
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
  for (i = 0; i < 10; i += 1)
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
  var passwordREGEX = /^(?=.*\d)(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z]).{8,50}$/;
  if (password.length === 0)
    return {
      valid: false,
      msg: "Password is required!",
    };

  if (!passwordREGEX.test(password))
    return {
      valid: false,
      msg: "Your password must be at least 8 characters long, contain at least one number, one symbol and have a mixture of uppercase and lowercase letters.Password should not exceed 50 characters!",
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

export function checkCVC(cvc) {
  if (cvc.length === 0)
    return {
      valid: false,
      msg: "cvc field is required!",
    };

  if (cvc.length !== 3)
    return {
      valid: false,
      msg: "Please enter a valid cvc number!",
    };

  var i;
  for (i = 0; i < 10; i += 1)
    if (cvc.charAt(i) < "0" || cvc.charAt(i) > "9")
      return {
        valid: false,
        msg: "Please enter a valid cvv number!",
      };

  return {
    valid: true,
    msg: "",
  };
}
