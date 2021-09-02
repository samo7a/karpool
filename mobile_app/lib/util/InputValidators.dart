class InputValidators {
  static Map<String, dynamic> checkFirstName(String name) {
    RegExp exp = RegExp(r"(/^[A-Za-z-,\s']+$/)");
    if (name.length <= 1)
      return {
        "valid": false,
        "msg": "First name should be at least 2 characters long!",
      };
    if (!exp.hasMatch(name))
      return {
        "valid": false,
        "msg": "Please enter a valid name!",
      };

    if (name.length > 50)
      return {
        "valid": false,
        "msg": "First Name should not exceed 50 characters!",
      };

    return {
      "valid": true,
      "msg": "",
    };
  }

  static Map<String, dynamic> checkLastName(String name) {
    RegExp exp = RegExp(r"(/^[A-Za-z-,\s']+$/)");
    if (name.length <= 1)
      return {
        "valid": false,
        "msg": "First name should be at least 2 characters long!",
      };
    if (!exp.hasMatch(name))
      return {
        "valid": false,
        "msg": "Please enter a valid name!",
      };

    if (name.length > 50)
      return {
        "valid": false,
        "msg": "First Name should not exceed 50 characters!",
      };

    return {
      "valid": true,
      "msg": "",
    };
  }

  static Map<String, dynamic> checkEmail(String email) {
    RegExp exp = RegExp(r"(/^[^\s@]+@[^\s@\d]+\.[^\s@\d]+$/)");
    if (email.length > 50)
      return {
        "valid": false,
        "msg": "Email is too long! Email should not exceed 50 characters!",
      };

    if (email.length == 0)
      return {
        "valid": false,
        "msg": "Email address field is required!",
      };

    if (!exp.hasMatch(email))
      return {
        "valid": false,
        "msg":
            "Please enter your email address in this format: yourname@example.com",
      };

    return {
      "valid": true,
      "msg": "",
    };
  }
}
