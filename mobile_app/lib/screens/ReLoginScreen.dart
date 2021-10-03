import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/screens/ForgotPassword.dart';
import 'package:mobile_app/util/Auth.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/widgets/PasswordField.dart';
import 'package:mobile_app/widgets/TextField.dart';
import 'package:mobile_app/widgets/rounded-button.dart';
import 'package:provider/provider.dart';

class ReLoginScreen extends StatefulWidget {
  static const String id = 'reLoginScreen';

  const ReLoginScreen({Key? key}) : super(key: key);

  @override
  _ReLoginScreenState createState() => _ReLoginScreenState();
}

class _ReLoginScreenState extends State<ReLoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> auth() async {
    String email = emailController.text.isEmpty ? "empty" : emailController.text.trim();
    String password = passwordController.text.isEmpty ? "empty" : passwordController.text.trim();
    EasyLoading.show(status: 'Making Sure you are who you are!!');
    try {
      final res = await context.read<Auth>().signIn(email, password);
      if (res != null) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess("Authenticated");
        Navigator.pop(context, email);
        return;
      } else {
        EasyLoading.dismiss();
        EasyLoading.showInfo("Wrong email or password!");
        Navigator.pop(context, null);
        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Error Confirming the user!");
      print(e.toString());
      Navigator.pop(context, null);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = new Size(Context: context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kDashboardColor,
        appBar: AppBar(
          backgroundColor: kDashboardColor,
          title: Text("Confirm User"),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: kWhite,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.all(size.BLOCK_HEIGHT * 1),
                  child: Text(
                    "You are about to change a critical information! \n Please, Enter your Old Email and Password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: size.FONT_SIZE * 20,
                    ),
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
                RoundedButton(
                  color: 0xFF0466CB,
                  buttonName: 'Confirm',
                  onClick: () async {
                    await auth();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
