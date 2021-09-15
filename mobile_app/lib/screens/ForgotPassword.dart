import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/util/Auth.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/rounded-button.dart';
import 'package:mobile_app/widgets/text-input-field.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatelessWidget {
  static const String id = 'forgotPassword';
  ForgotPassword({Key? key}) : super(key: key);
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = new Size(Context: context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kBackgroundColor,
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
            'Forgot Password',
            style: kBodyText,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: size.BLOCK_WIDTH * 10,
                  right: size.BLOCK_WIDTH * 10,
                ),
                child: Text(
                  'Enter your email we will send a code to reset your password',
                  style: TextStyle(
                    fontSize: size.FONT_SIZE * 30,
                    color: Colors.white,
                  ),
                ),
              ),
              TextInputField(
                controller: emailController,
                icon: FontAwesomeIcons.envelope,
                hint: 'Email',
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.done,
              ),
              RoundedButton(
                buttonName: 'Send',
                onClick: () async {
                  EasyLoading.show(status: "Sending ...");
                  try {
                    await Provider.of<Auth>(context, listen: false)
                        .sendResetPasswordEmail(emailController.text.trim());
                    EasyLoading.dismiss();
                    EasyLoading.showSuccess("Email Sent!");
                    Navigator.pop(context);
                  } catch (e) {
                    EasyLoading.showError("Failed! Please try again");
                    print(e.toString());
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
