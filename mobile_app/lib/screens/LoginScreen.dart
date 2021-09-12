import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  static const String id = 'loginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isDriver = false;

  void login() async {
    final user = await Provider.of<User?>(context, listen: false);
    String email = emailController.text.isEmpty ? "empty" : emailController.text.trim();
    String password = passwordController.text.isEmpty ? "empty" : passwordController.text.trim();
    EasyLoading.show(status: 'Signing in...');
    final prefs = await SharedPreferences.getInstance();
    try {
      if (isDriver)
        await prefs.setString("role", "driver");
      else
        await prefs.setString("role", "rider");
      ;
      final res = await context.read<Auth>().signIn(email, password);
      if (res != null) {
        bool verified = res.isVerified;
        if (!verified) {
          context.read<Auth>().signOut();
          await prefs.setString("role", "norole");
          user != null ? user.sendEmailVerification() : null;
          EasyLoading.dismiss();
          EasyLoading.showInfo("Unverified user");
          return;
        } else {
          bool driverRole = res.isDriver;
          bool riderRole = res.isRider;
          if (isDriver && driverRole) {
            //the user is driver
            await prefs.setString("role", "driver");
            EasyLoading.dismiss();
            EasyLoading.showSuccess("Logged in!");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => DriverDashboardScreen(),
                settings: RouteSettings(
                  arguments: res,
                ),
              ),
              (Route<dynamic> route) => false,
            );
          } else if (!isDriver && riderRole) {
            // the user is a rider
            await prefs.setString("role", "rider");
            EasyLoading.dismiss();
            EasyLoading.showSuccess("Logged in!");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => RiderDashboardScreen(),
                settings: RouteSettings(
                  arguments: res,
                ),
              ),
              (Route<dynamic> route) => false,
            );
          } else {
            //has no roles
            EasyLoading.dismiss();
            context.read<Auth>().signOut();
            EasyLoading.showError("Signing in failed, please try agin!");
            return;
          }
        }
      } else {
        EasyLoading.dismiss();
        context.read<Auth>().signOut();
        await prefs.setString("role", "norole");
        EasyLoading.showInfo("Signing in failed, please try agin!");
        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      context.read<Auth>().signOut();
      EasyLoading.showError("Change your user type.");
      // EasyLoading.showError(e.toString());
      // print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = new Size(Context: context);
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
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT, bottom: size.BLOCK_HEIGHT * 2),
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
                  login();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
