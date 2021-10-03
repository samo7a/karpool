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
import 'package:mobile_app/widgets/PasswordField.dart';
import 'package:mobile_app/widgets/TextField.dart';
import 'package:mobile_app/widgets/rounded-button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'driver/DriverDashboardScreen.dart';
import 'package:mobile_app/models/User.dart' as u;

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

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    final user = Provider.of<User>(context, listen: false);
    String email = emailController.text.isEmpty ? "empty" : emailController.text.trim();
    String password = passwordController.text.isEmpty ? "empty" : passwordController.text.trim();
    EasyLoading.show(status: 'Signing in...');
    final prefs = await SharedPreferences.getInstance();
    try {
      if (isDriver)
        await prefs.setString("role", "driver");
      else
        await prefs.setString("role", "rider");

      final res = await context.read<Auth>().signIn(email, password);
      u.User currentUser = Provider.of<u.User>(context, listen: false);

      if (res != null) {
        bool verified = res.isVerified;
        if (!verified) {
          user.sendEmailVerification();
          context.read<Auth>().signOut();
          await prefs.setString("role", "norole");
          EasyLoading.dismiss();
          EasyLoading.showInfo("Unverified user");
          return;
        } else {
          currentUser.setFirstName = res.firstName;
          currentUser.setLastName = res.lastName;
          currentUser.setEmail = res.email;
          currentUser.setUid = res.uid;
          currentUser.setIsDriver = res.isDriver;
          currentUser.setIsRider = res.isRider;
          currentUser.setIsVerified = res.isVerified;
          currentUser.setPhoneNumber = res.phoneNumber;
          currentUser.setRating = res.rating;
          currentUser.setProfileURL = res.profileURL;
          bool driverRole = res.isDriver;
          bool riderRole = res.isRider;
          if (isDriver && driverRole) {
            //the user is driver
            await prefs.setString("role", "driver");
            EasyLoading.dismiss();
            EasyLoading.showSuccess("Logged in!");
            Navigator.pushNamedAndRemoveUntil(
              context,
              DriverDashboardScreen.id,
              (Route<dynamic> route) => false,
            );
          } else if (!isDriver && riderRole) {
            // the user is a rider
            await prefs.setString("role", "rider");
            EasyLoading.dismiss();
            EasyLoading.showSuccess("Logged in!");
            Navigator.pushNamedAndRemoveUntil(
              context,
              RiderDashboardScreen.id,
              (Route<dynamic> route) => false,
            );
          } else {
            //has no roles
            EasyLoading.dismiss();
            context.read<Auth>().signOut();
            EasyLoading.showError("Signing in failed, please try again!");
            return;
          }
        }
      } else {
        EasyLoading.dismiss();
        context.read<Auth>().signOut();
        await prefs.setString("role", "norole");
        EasyLoading.showInfo("Signing in failed, please try again!");
        return;
      }
    } catch (e) {
      await prefs.setString("role", "norole");
      EasyLoading.dismiss();
      context.read<Auth>().signOut();
      EasyLoading.showError("Signing in failed, please try again!");
      await prefs.setString("role", "norole");
      // EasyLoading.showError(e.toString());
      print(e.toString());
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
          title: Text("Sign In"),
          centerTitle: true,
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
                  height: size.BLOCK_HEIGHT * 6,
                  width: size.BLOCK_WIDTH * 26,
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
                color: 0xFF0466CB,
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
