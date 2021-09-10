import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/screens/LoginScreen.dart';
import 'package:mobile_app/screens/RegisterScreen.dart';
import '../util/Size.dart';
import 'package:mobile_app/util/constants.dart';

class MainScreen extends StatelessWidget {
  static const id = 'mainScreen';
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
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
                Padding(
                  padding: EdgeInsets.all(size.BLOCK_HEIGHT * 2),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    minWidth: size.BLOCK_WIDTH * 70,
                    height: size.BLOCK_HEIGHT * 7,
                    color: kButtonColor,
                    child: Text('Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.FONT_SIZE * 28,
                        )),
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(size.BLOCK_HEIGHT * 2),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    minWidth: size.BLOCK_WIDTH * 70,
                    height: size.BLOCK_HEIGHT * 7,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    color: kButtonColor,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.FONT_SIZE * 28,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterScreen.id);
                    },
                  ),
                )
              ],
            ),
          )),
        ));
  }
}

// Image(
                //   image: AssetImage('images/splashIcon.png'),
                //   width: size.BLOCK_WIDTH * 60,
                //   height: size.BLOCK_HEIGHT * 60,
                // ),
