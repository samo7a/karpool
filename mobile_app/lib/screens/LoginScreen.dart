import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/screens/ForgotPassword.dart';
import 'package:mobile_app/screens/rider/RiderDashboardScreen.dart';
import 'package:mobile_app/util/Auth.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'driver/DriverDashboardScreen.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'loginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isDriver = false;

  void login(BuildContext context) async {
    String email = emailController.text.isEmpty ? "empty" : emailController.text;
    String password = passwordController.text.isEmpty ? "empty" : passwordController.text;
    EasyLoading.show(status: 'Signing in...');
    final prefs = await SharedPreferences.getInstance();
    try {
      HttpsCallable getUser = FirebaseFunctions.instance.httpsCallable.call('account-getUser');
      final res = await context.read<Auth>().signIn(email, password);
      if (res["msg"].toString().isEmpty) {
        if (res["data"].user.emailVerified) {
          context.read<Auth>().signOut();
          EasyLoading.dismiss();
          EasyLoading.showInfo("Unverified user");
          return;
        } else {
          String uid = res["data"].user.uid;
          final obj = <String, dynamic>{
            "uid": uid,
            "driver": isDriver,
          };
          final result = await getUser(obj);
          var riderRole = result.data['roles']['Rider'];
          var driverRole = result.data["roles"]["Driver"];
          if (isDriver == true && driverRole != null) {
            //the user is driver
            prefs.setString("role", "driver");
            EasyLoading.dismiss();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DriverDashboardScreen()),
              (Route<dynamic> route) => false,
            );
          } else if (isDriver == false && riderRole != null) {
            // the user is a rider
            prefs.setString("role", "rider");
            EasyLoading.dismiss();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => RiderDashboardScreen()),
              (Route<dynamic> route) => false,
            );
          } else {
            //has no roles
            EasyLoading.dismiss();
            context.read<Auth>().signOut();
            EasyLoading.showError("Signing in failed, please try agin!");
          }
        }
      } else {
        EasyLoading.dismiss();
        EasyLoading.showInfo(res['msg']);
        return;
      }
      //final results = await getUser();
    } catch (e) {
      EasyLoading.dismiss();
      context.read<Auth>().signOut();
      EasyLoading.showError("Change your user type.");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = new Size(Context: context);
    return Provider<Auth>(
      create: (_) => Auth(FirebaseAuth.instance),
      child: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: kBackgroundColor,
              appBar: AppBar(
                backgroundColor: kBackgroundColor,
                title: Text("SIGN IN"),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(size.BLOCK_HEIGHT * 1),
                      child: Image(
                        image: AssetImage('images/splashIcon.png'),
                        color: kWhite,
                        height: size.BLOCK_HEIGHT * 30,
                        width: size.BLOCK_WIDTH * 30,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.BLOCK_HEIGHT * 2),
                      child: TextInputField(
                        icon: FontAwesomeIcons.envelope,
                        hint: 'Email',
                        inputType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                        controller: emailController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
                      child: PasswordInput(
                        controller: passwordController,
                        icon: FontAwesomeIcons.lock,
                        hint: 'Password',
                        inputType: TextInputType.visiblePassword,
                        inputAction: TextInputAction.done,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: size.BLOCK_HEIGHT, bottom: size.BLOCK_HEIGHT * 2),
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, ForgotPassword.id),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: size.FONT_SIZE * 15,
                            color: kButtonColor,
                            decoration: TextDecoration.underline,
                            decorationThickness: 1,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.BLOCK_HEIGHT * 2),
                      child: FlutterSwitch(
                        height: size.BLOCK_HEIGHT * 7,
                        width: size.BLOCK_WIDTH * 29,
                        toggleSize: 35.0,
                        value: isDriver,
                        borderRadius: 30.0,
                        showOnOff: true,
                        activeText: 'Driver',
                        inactiveText: 'Rider',
                        inactiveTextColor: Color(0xFF0466CB),
                        padding: 2.0,
                        activeToggleColor: Color(0xFF0582ff),
                        inactiveToggleColor: Color(0xFF0466CB),
                        activeSwitchBorder: Border.all(
                          color: Color(0xFF0466CB),
                          width: 6.0,
                        ),
                        inactiveSwitchBorder: Border.all(
                          color: Color(0xFFD1D5DA),
                          width: 6.0,
                        ),
                        activeColor: Color(0xFF00439c),
                        inactiveColor: Colors.white,
                        activeIcon: Icon(
                          Icons.directions_car,
                          color: kWhite,
                          size: 22,
                        ),
                        inactiveIcon: Icon(
                          Icons.hail,
                          color: kWhite,
                          size: 22,
                        ),
                        onToggle: (value) {
                          setState(() {
                            isDriver = value;
                          });
                        },
                      ),
                    ),
                    RoundedButton(
                      buttonName: 'Login',
                      onClick: () {
                        login(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
