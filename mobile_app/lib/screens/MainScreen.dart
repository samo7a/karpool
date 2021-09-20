import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/screens/LoginScreen.dart';
import 'package:mobile_app/screens/RegisterScreen.dart';
import 'package:mobile_app/widgets/widgets.dart';
import '../util/Size.dart';
import 'package:mobile_app/util/constants.dart';

class MainScreen extends StatelessWidget {
  static const String id = 'mainScreen';
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Kärpōōl',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: size.FONT_SIZE * 50,
                ),
              ),
              SizedBox(
                height: size.BLOCK_HEIGHT * 4,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.BLOCK_WIDTH * 8),
                child: Text(
                  'Ensuring mobility in a mobile world.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Glory',
                    fontWeight: FontWeight.bold,
                    fontSize: size.FONT_SIZE * 25,
                  ),
                ),
              ),
              SizedBox(
                height: size.BLOCK_HEIGHT * 20,
              ),
              RoundedButton(
                color: 0xFF0466CB,
                buttonName: 'Login',
                onClick: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
              RoundedButton(
                color: 0xFF0466CB,
                buttonName: 'Sign Up',
                onClick: () {
                  Navigator.pushNamed(context, RegisterScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
