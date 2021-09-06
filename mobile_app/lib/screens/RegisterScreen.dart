import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/pallete.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RegisterScreen extends StatefulWidget {
  static const id = 'registerScreen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String firstName = '';
  String firstName = '';
  String firstName = '';
  String firstName = '';
  String firstName = '';
  String firstName = '';

  void validate() {
    if (formkey.currentState!.validate()) {
      print("Validated");
    } else {
      print("Not Validated");
    }
  }

  void validate2() {
    RegExp regex = new RegExp(r"/^[^\s@]+@[^\s@\d]+.[^\s@\d]+$/");
    print(regex.hasMatch("samo@ll.co"));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: kWhite,
          ),
        ),
        title: Text(
          'Register',
          style: kBodyText,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Center(
          child: Form(
            autovalidateMode: AutovalidateMode.always, // Auto Validation Check
            key: formkey,

            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: CircleAvatar(
                    radius: size.width * 0.14,
                    backgroundColor: Colors.transparent,
                    child: Image(
                      image: AssetImage('images/splashIcon.png'),
                      color: kWhite,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: TextFormField(
                      decoration: InputDecoration(
                          fillColor: kBlack.withOpacity(0.1),
                          filled: true,
                          prefixIcon:
                              Icon(FontAwesomeIcons.signature, color: kWhite),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kGreen, width: 5),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kRed, width: 5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kGreen, width: 5),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kRed, width: 5),
                          ),
                          hintStyle: TextStyle(color: kHintText),
                          hintText: "First Name"),
                      validator: MultiValidator([
                        RequiredValidator(errorText: "First Name is Required!"),
                        MinLengthValidator(2,
                            errorText:
                                "First name should be at least 2 characters long!"),
                        MaxLengthValidator(50,
                            errorText:
                                "First name should not exceed 50 characters!"),
                        PatternValidator(r"(^[A-Za-z-,\s']+$)",
                            errorText: "Please enter a valid name!"),
                      ]),
                      onChanged: (value) => setState(() => firstName = value),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                          color: kWhite, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                      decoration: InputDecoration(
                          fillColor: kBlack.withOpacity(0.1),
                          filled: true,
                          prefixIcon:
                              Icon(FontAwesomeIcons.signature, color: kWhite),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kGreen, width: 5),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kRed, width: 5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kGreen, width: 5),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kRed, width: 5),
                          ),
                          hintStyle: TextStyle(color: kHintText),
                          hintText: "Last Name"),
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Last Name is Required!"),
                        MinLengthValidator(2,
                            errorText:
                                "Last name should be at least 2 characters long!"),
                        MaxLengthValidator(50,
                            errorText:
                                "Last name should not exceed 50 characters!"),
                        PatternValidator(r"(^[A-Za-z-,\s']+$)",
                            errorText: "Please enter a valid name!"),
                      ]),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                          color: kWhite, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                      decoration: InputDecoration(
                          fillColor: kBlack.withOpacity(0.1),
                          filled: true,
                          prefixIcon:
                              Icon(FontAwesomeIcons.envelope, color: kWhite),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kGreen, width: 5),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kRed, width: 5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kGreen, width: 5),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kRed, width: 5),
                          ),
                          hintStyle: TextStyle(color: kHintText),
                          hintText: "Email Address"),
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: "Email Address is Required!"),
                        EmailValidator(
                            errorText: "Please enter a valid email!"),
                        MaxLengthValidator(50,
                            errorText:
                                "Email should not exceed 50 characters!"),
                      ]),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                          color: kWhite, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                      decoration: InputDecoration(
                          fillColor: kBlack.withOpacity(0.1),
                          filled: true,
                          prefixIcon:
                              Icon(FontAwesomeIcons.phoneAlt, color: kWhite),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kGreen, width: 5),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kRed, width: 5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kGreen, width: 5),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kRed, width: 5),
                          ),
                          hintStyle: TextStyle(color: kHintText),
                          hintText: "Phone Number"),
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: "Phone Number is Required!"),
                        MaxLengthValidator(10,
                            errorText:
                                "Phone Number should not exceed 10 digits!"),
                        MinLengthValidator(10,
                            errorText:
                                "Phone Number should not be less than 10 digits!"),
                        PatternValidator(r"^[0-9]{10}$",
                            errorText: "Please enter a valid phone number!"),
                      ]),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                          color: kWhite, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: kBlack.withOpacity(0.1),
                          filled: true,
                          prefixIcon:
                              Icon(FontAwesomeIcons.lock, color: kWhite),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kGreen, width: 5),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kRed, width: 5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kGreen, width: 5),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kRed, width: 5),
                          ),
                          hintStyle: TextStyle(color: kHintText),
                          hintText: "Password"),
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Password is Required!"),
                        // MaxLengthValidator(50,
                        //     errorText:
                        //         "Password should not exceed 50 characters!"),
                        // MinLengthValidator(6,
                        //     errorText:
                        //         'Password must be at least 8 digits long!'),
                        PatternValidator(
                            r"^(?=.*\d)(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z]).{6,50}$",
                            // ^(?=.[0-9])(?=.[a-zA-Z])(?=\S+$).{6,50}$ // Updated one not working...
                            errorText:
                                'Password must contain one symbol and number!')
                      ]),
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                          color: kWhite, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                      obscureText: true,
                      //onChanged: (val) => password = val,
                      decoration: InputDecoration(
                          fillColor: kBlack.withOpacity(0.1),
                          filled: true,
                          prefixIcon:
                              Icon(FontAwesomeIcons.lock, color: kWhite),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kGreen, width: 5),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kRed, width: 5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kGreen, width: 5),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kRed, width: 5),
                          ),
                          hintStyle: TextStyle(color: kHintText),
                          hintText: "Confirm Password"),
                      //validator: (val) => MatchValidator(errorText: 'passwords do not match').validateMatch(val!, password),
                      textInputAction: TextInputAction.done,
                      style: TextStyle(
                          color: kWhite, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: ElevatedButton(
                    onPressed: () {
                      validate();
                      validate2();
                    },
                    child: Text("Register"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
