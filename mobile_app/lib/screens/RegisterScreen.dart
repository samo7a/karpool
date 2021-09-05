import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/pallete.dart';
import 'package:mobile_app/util/InputValidators.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RegisterScreen extends StatefulWidget {
  static const id = 'registerScreen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void validate() {
    if (formkey.currentState!.validate()) {
      print("Validated");
    } else {
      print("Not Validated");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey, // Temp Background Color
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
                        border: OutlineInputBorder(), labelText: "First Name"),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "First Name is Required!"),
                      MinLengthValidator(2,
                          errorText:
                              "First name should be at least 2 characters long!"),
                      MaxLengthValidator(50,
                          errorText:
                              "First name should not exceed 50 characters!"),
                      PatternValidator(r"(/^[A-Za-z-,\s']+$/)",
                          errorText: "Please enter valid name!"),
                    ]),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Last Name"),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Last Name is Required!"),
                      MinLengthValidator(2,
                          errorText:
                              "Last name should be at least 2 characters long!"),
                      MaxLengthValidator(50,
                          errorText:
                              "Last name should not exceed 50 characters!"),
                      PatternValidator(r"(/^[A-Za-z-,\s']+$/)",
                          errorText: "Please enter valid name!"),
                    ]),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email Address"),
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: "Email Address is Required!"),
                      EmailValidator(errorText: "Enter Valid Email"),
                      MaxLengthValidator(50,
                          errorText: "Email should not exceed 50 characters!"),
                    ]),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Phone Number"),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Phone Number is Required!"),
                      //PatternValidator(pattern, errorText: errorText),
                    ]),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Password"),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Password is Required!"),
                      MinLengthValidator(8,
                          errorText:
                              'Password must be at least 8 digits long!'),
                      //PatternValidator("r(/^(?=.*\d)(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z]).{8,50}$/)", errorText: "Please enter valid password!"),
                    ]),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    obscureText: true,
                    //onChanged: (val) => password = val,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Confirm Password"),
                    //validator: (val) => MatchValidator(errorText: 'passwords do not match').validateMatch(val!, password),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: ElevatedButton(
                    onPressed: validate,
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
