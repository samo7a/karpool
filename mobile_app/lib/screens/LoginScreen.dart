import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/pallete.dart';
import 'package:mobile_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.blueGrey,
          body: Column(
            children: [
              Flexible(
                child: Center(
                  child: Image(
                    image: AssetImage('images/splashIcon.png'),
                    color: kWhite,
                    height: 150,
                    width: 150,
                  ),
                ),
              ),
              // Flexible(
              //   child: Center(
              //     child: Text(
              //       'Welcome back to Karpool!',
              //       style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 25,
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextInputField(
                    icon: FontAwesomeIcons.envelope,
                    hint: 'Email',
                    inputType: TextInputType.emailAddress,
                    inputAction: TextInputAction.next,
                  ),
                  PasswordInput(
                    icon: FontAwesomeIcons.lock,
                    hint: 'Password',
                    inputType: TextInputType.visiblePassword,
                    inputAction: TextInputAction.done,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'ForgotPassword'),
                    child: Text(
                      'Forgot Password',
                      style: kBodyText,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  RoundedButton(
                    buttonName: 'Login',
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'CreateNewAccount'),
                child: Container(
                  child: Text(
                    'Create New Account',
                    style: kBodyText,
                  ),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(width: 1, color: kWhite))),
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        )
      ],
    );
  }
}
