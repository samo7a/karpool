import 'package:flutter/material.dart';
import 'package:mobile_app/screens/ForgotPassword.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/Auth.dart';
import 'dart:io' as Io;
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_app/screens/MainScreen.dart';

class EditProfilScreen extends StatefulWidget {
  const EditProfilScreen({Key? key}) : super(key: key);
  static const String id = "editProfilScreen";
  @override
  _EditProfilScreenState createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String newEmail = "";
  String newPhone = "";

  void updateEmail(String value) async {
    try {
      await context.read<Auth>().updateEmail(value);
      EasyLoading.showInfo("Verify your new email and log back in.");
      await context.read<Auth>().signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      EasyLoading.showInfo(e.toString());
    }
  }

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
    // TODO: Link image change to backend
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Change Profile Picture",
            style: TextStyle(
              fontSize: 20,
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
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    Size size = Size(Context: context);
    String fname = user.firstName;
    String lname = user.lastName;
    String phone = user.phoneNumber;
    String email = user.email;
    String profilePic = user.profileURL;

    return Scaffold(
      backgroundColor: Color(0xff33415C),
      appBar: AppBar(
        backgroundColor: Color(0xff33415C),
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
          child: Padding(
            padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 4),
            child: Form(
              autovalidateMode: AutovalidateMode.always, // Auto Validation Check
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "$fname $lname",
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
                        backgroundImage: _imageFile == null
                            ? NetworkImage(
                                profilePic,
                              ) as ImageProvider
                            : FileImage(Io.File(_imageFile!.path)),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => bottomSheet(),
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
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    height: size.BLOCK_HEIGHT,
                  ),
                  Container(
                      child: TextFormField(
                        onChanged: (value) => setState(() => newEmail = value),
                        keyboardType: TextInputType.emailAddress,
                        initialValue: email,
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
                      onPressed: () {
                        if (newEmail == email)
                          EasyLoading.showInfo("Email does not differ from initial email.");
                        else if (newEmail == "")
                          EasyLoading.showInfo("Email has not been changed.");
                        else {
                          updateEmail(newEmail);
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
                      child: TextFormField(
                        onChanged: (value) => setState(() => newPhone = value),
                        keyboardType: TextInputType.emailAddress,
                        initialValue: phone,
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
                      onPressed: () {
                        // TODO: call api for changing phone number
                      },
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
