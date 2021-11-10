import 'dart:convert';
// import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/screens/ForgotPassword.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/models/User.dart' as u;
import 'package:mobile_app/screens/ReLoginScreen.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/Auth.dart';
import 'dart:io' as Io;
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'MainScreen.dart';

class EditProfilScreen extends StatefulWidget {
  const EditProfilScreen({Key? key}) : super(key: key);
  static const String id = "editProfilScreen";
  @override
  _EditProfilScreenState createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  late final user = Provider.of<u.User>(context, listen: false);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  String phoneString = "";
  String profilePic = "";
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> updateEmail(String value, u.User user) async {
    try {
      await context.read<Auth>().updateEmail(value.trim());
      EasyLoading.showInfo("Verify your new email and log back in.");
      setState(() {
        user.setEmail = value;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("error in update email");
      print(e.toString());
      EasyLoading.showInfo("Error updating your email");
    }
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 25,
    );
    print(pickedFile);
    setState(() {
      _imageFile = pickedFile;
    });
    print(await pickedFile!.length());
    EasyLoading.show(status: "Uploading the profile pic");
    String img64;
    if (_imageFile == null) {
      EasyLoading.dismiss();
      EasyLoading.showError("Please upload a profile picture");
      return;
    } else {
      final bytes = Io.File(_imageFile!.path).readAsBytesSync();
      img64 = base64Encode(bytes);
    }
    print("base 64 string : " + img64);
    Map<String, dynamic> obj = {
      "uid": user.uid,
      "pic": img64,
    };
    HttpsCallable updatePhoto =
        FirebaseFunctions.instance.httpsCallable.call('account-editUserProfile');
    try {
      await updatePhoto(obj);
      final u;
      if (user.isDriver == true)
        u = await User.getDriverFromFireBase(user.uid);
      else
        u = await User.getRiderFromFireBase(user.uid);
      user.setProfileURL = u.getProfileURL;
      EasyLoading.dismiss();
      EasyLoading.showSuccess("Profile picture updated");
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Error uploading the profile picture.");
    }
  }

  void changePhoneNum() async {
    EasyLoading.show(status: "Updating phone number!");
    // if (!formKey.currentState!.validate()) {
    //   EasyLoading.dismiss();
    //   EasyLoading.showError("Enter a valid phone number!");
    //   return;
    // }
    String phoneNumber = user.getPhoneNumber;
    String newPhoneNumber = phoneString;
    if (phoneNumber.trim() == newPhoneNumber.trim()) {
      EasyLoading.dismiss();
      EasyLoading.showError("Try to add a different phone number!");
      return;
    }
    HttpsCallable changePhoneNumber =
        FirebaseFunctions.instance.httpsCallable("account-editUserProfile");
    Map<String, dynamic> obj = {
      "uid": user.uid,
      "phoneNum": newPhoneNumber,
    };
    try {
      print("inside the try");
      final result = await changePhoneNumber(obj);
      final data = result.data;
      print(result);
      print(data);
      user.setPhoneNumber = newPhoneNumber;
      EasyLoading.dismiss();
      EasyLoading.showSuccess("Phone number updated!");
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Error updating the phone number.");
    }
  }

  Widget bottomSheet(BuildContext context) {
    Size size = Size(Context: context);
    return Container(
      height: size.BLOCK_HEIGHT * 13,
      margin: EdgeInsets.symmetric(
        vertical: size.BLOCK_HEIGHT * 3,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Change Profile Picture",
            style: TextStyle(
              fontSize: size.FONT_SIZE * 15,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                onPressed: () async {
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: Text("Camera"),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: Icon(Icons.image),
                label: Text("Gallery"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _imageFile = null;
    phoneString = user.getPhoneNumber;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    // phoneController.text = user.phoneNumber;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kDashboardColor,
        appBar: AppBar(
          backgroundColor: kDashboardColor,
          title: Text("Edit Profile"),
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
          child: Center(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${user.firstName} ${user.lastName}",
                    style: TextStyle(
                      fontFamily: 'Glory',
                      fontSize: size.FONT_SIZE * 32,
                      fontWeight: FontWeight.bold,
                      color: kWhite,
                    ),
                  ),
                  SizedBox(
                    height: size.BLOCK_HEIGHT * 6,
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.transparent,
                          backgroundImage: _imageFile != null
                              ? FileImage(Io.File(_imageFile!.path))
                              : NetworkImage(
                                  user.getProfileURL,
                                ) as ImageProvider
                          // : AssetImage("images/chris.jpg"),
                          ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => bottomSheet(context),
                            );
                          },
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.BLOCK_HEIGHT,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.BLOCK_HEIGHT, bottom: size.BLOCK_HEIGHT * 2),
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, ForgotPassword.id),
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                          fontFamily: 'Glory',
                          fontSize: size.FONT_SIZE * 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          decoration: TextDecoration.underline,
                          decorationThickness: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.BLOCK_HEIGHT * 5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: size.BLOCK_WIDTH * 40),
                    child: Text(
                      "Email Address",
                      style: TextStyle(
                        fontSize: size.FONT_SIZE * 18,
                        color: kWhite,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.BLOCK_HEIGHT,
                  ),
                  Container(
                    child: TextFormField(
                      enabled: false,
                      initialValue: user.email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email Address",
                        hintStyle: TextStyle(fontSize: size.FONT_SIZE * 15),
                        contentPadding: EdgeInsets.all(size.BLOCK_WIDTH * 2),
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(
                            color: kRed,
                            width: size.BLOCK_WIDTH,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    height: size.BLOCK_HEIGHT * 6,
                    width: size.BLOCK_WIDTH * 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: kWhite,
                    ),
                  ),
                  SizedBox(
                    height: size.BLOCK_HEIGHT,
                  ),
                  Container(
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "New Email Address",
                          hintStyle: TextStyle(
                            fontSize: size.FONT_SIZE * 15,
                          ),
                          contentPadding: EdgeInsets.all(
                            size.BLOCK_WIDTH * 2,
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                              color: kRed,
                              width: size.BLOCK_WIDTH,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        validator: MultiValidator(
                          [
                            RequiredValidator(
                              errorText: "Email address is required!",
                            ),
                            EmailValidator(
                              errorText: "Please enter a valid email!",
                            ),
                            MaxLengthValidator(
                              50,
                              errorText: "Email should not exceed 50 characters!",
                            ),
                          ],
                        ),
                      ),
                      height: size.BLOCK_HEIGHT * 6,
                      width: size.BLOCK_WIDTH * 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: kWhite,
                      )),
                  Padding(
                    padding: EdgeInsets.only(right: size.BLOCK_WIDTH * 30),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      minWidth: size.BLOCK_WIDTH * 30,
                      height: size.BLOCK_HEIGHT * 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      color: Colors.green,
                      child: Text(
                        'Confirm Change',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.FONT_SIZE * 18,
                        ),
                      ),
                      onPressed: () async {
                        String? email = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => ReLoginScreen(),
                          ),
                        );
                        if (email == null) {
                          return;
                        }
                        print(emailController.text);
                        if (email.trim() == emailController.text.trim())
                          EasyLoading.showInfo("Email does not differ from initial email.");
                        else {
                          await updateEmail(emailController.text.trim(), user);
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.BLOCK_HEIGHT * 5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: size.BLOCK_WIDTH * 39),
                    child: Text(
                      "Phone Number",
                      style: TextStyle(
                        fontSize: size.FONT_SIZE * 18,
                        color: kWhite,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    height: size.BLOCK_HEIGHT,
                  ),
                  Container(
                      child: Consumer<u.User>(
                        builder: (context, value, child) {
                          return TextFormField(
                            onChanged: (value) => setState(() {
                              phoneString = value;
                            }),
                            initialValue: phoneString,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone Number",
                              hintStyle: TextStyle(fontSize: size.FONT_SIZE * 15),
                              contentPadding: EdgeInsets.all(size.BLOCK_WIDTH * 2),
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                  color: kRed,
                                  width: size.BLOCK_WIDTH,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            validator: MultiValidator(
                              [
                                RequiredValidator(errorText: "Phone number is required!"),
                                MaxLengthValidator(10,
                                    errorText: "Phone number should not exceed 10 digits!"),
                                MinLengthValidator(10,
                                    errorText: "Phone number should not be less than 10 digits!"),
                                PatternValidator(r"^[0-9]{10}$",
                                    errorText: "Please enter a valid phone number!"),
                              ],
                            ),
                          );
                        },
                      ),
                      height: size.BLOCK_HEIGHT * 6,
                      width: size.BLOCK_WIDTH * 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: kWhite,
                      )),
                  Padding(
                    padding: EdgeInsets.only(right: size.BLOCK_WIDTH * 30),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      minWidth: size.BLOCK_WIDTH * 30,
                      height: size.BLOCK_HEIGHT * 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      color: Colors.green,
                      child: Text(
                        'Confirm Change',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.FONT_SIZE * 18,
                        ),
                      ),
                      onPressed: changePhoneNum,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
