import 'dart:io' as Io;
import 'dart:convert';
import 'dart:ui';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/screens/screens.dart';
import 'package:mobile_app/util/Auth.dart';
import 'package:mobile_app/util/CarModels.dart';
import 'package:mobile_app/util/InsuranceProviders.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/widgets/rounded-button.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'registerScreen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> userFormkey = GlobalKey<FormState>();
  GlobalKey<FormState> driverFormkey = GlobalKey<FormState>();

  TextEditingController _pass = TextEditingController();
  TextEditingController _confirmPass = TextEditingController();
  DateTime selectedDate = DateTime.now();

  // photo vars
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Widget bottomSheet() {
    return Container(
      height: 100,
      // width: ,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose profile photo",
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

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

// User Strings
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String dob = '';
  String gender = '';
  String password = '';

// Driver Bank Info Strings
  String routingNum = '';
  String accountNum = '';

// Driver Car Info Strings
  String carBrand = '';
  String carColor = '';
  String carYear = '';
  String carPlate = '';
  String driverLicense = '';
  String licenseEnd = '';

  List<String> insuranceProviders = providers;
  List<String> carModels = cars;
  List<String> colors = [];

  initState() {
    super.initState();
    _imageFile = null;
    for (int i = 0; i < carColors.length; i++) {
      colors.add(carColors[i]['label']);
    }
  }

// Driver Car Insurance Info Strings
  String insProvider = '';
  String insType = '';
  String insStartDate = '';
  String insEndDate = '';

  bool isDriver = false;

  bool userValidate() {
    if (userFormkey.currentState!.validate())
      return true;
    else
      return false;
  }

  bool driverValidate() {
    if (driverFormkey.currentState!.validate())
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = new Size(Context: context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
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
              'Register',
              style: kBodyText,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                vertical: size.BLOCK_HEIGHT * 2, horizontal: size.BLOCK_WIDTH * 3.5),
            child: Column(
              children: [
                Center(child: _getUserWidget(size)),
                isDriver ? _getDriverWidget(size) : Container(),
                Center(child: _getRegisterButtonWidget()),
              ],
            ),
          )),
    );
  }

  _getDriverWidget(Size size) {
    return Center(
      child: Form(
        autovalidateMode: AutovalidateMode.always, // Auto Validation Check
        key: driverFormkey,

        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: Text(
                'Bank Information',
                style: TextStyle(color: Color(0xFF33415C), fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 1),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.moneyCheckAlt, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                        borderSide: BorderSide(
                          color: kGreen,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Routing Number"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Routing Number is Required!"),
                    MinLengthValidator(9, errorText: "Please enter a valid Routing Number!"),
                    MaxLengthValidator(9, errorText: "Please enter a valid Routing Number!")
                  ]),
                  onChanged: (value) => setState(() => routingNum = value),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.moneyCheck, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                        borderSide: BorderSide(
                          color: kGreen,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Account Number"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Account Number is Required!"),
                    MinLengthValidator(9, errorText: "Please enter a valid Account Number!"),
                    MaxLengthValidator(12, errorText: "Please enter a valid Account Number!")
                  ]),
                  onChanged: (value) => setState(() => accountNum = value),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: Text(
                'Car Information',
                style: TextStyle(color: Color(0xFF33415C), fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 1),
              child: DropdownSearch<String>(
                  autoValidateMode: AutovalidateMode.always,
                  // validator: (value) {},
                  mode: Mode.BOTTOM_SHEET,
                  showSearchBox: true,
                  validator: RequiredValidator(errorText: "Car Brand is required!"),
                  dropdownSearchDecoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.car, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                        borderSide: BorderSide(
                          color: kGreen,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      labelStyle: TextStyle(color: kHintText),
                      labelText: "Car Brand"),
                  items: carModels,
                  onChanged: (value) => setState(() => carBrand = value!),
                  selectedItem: ""),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: DropdownSearch<String>(
                  autoValidateMode: AutovalidateMode.always,
                  mode: Mode.BOTTOM_SHEET,
                  showSearchBox: true,
                  validator: RequiredValidator(errorText: "Car Color is required!"),
                  dropdownSearchDecoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.palette, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                        borderSide: BorderSide(
                          color: kGreen,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      labelStyle: TextStyle(color: kHintText),
                      labelText: "Car Color"),
                  items: colors,
                  onChanged: (value) {
                    setState(() {
                      carColor = value!;
                    });
                  },
                  selectedItem: ""),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.calendar, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                        borderSide: BorderSide(
                          color: kGreen,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Year of Manufacture"),
                  validator: (value) {
                    int diff;
                    if (value != null) {
                      int currentYear = DateTime.now().year;
                      int val;
                      val = int.tryParse(value) ?? 0;
                      diff = currentYear - val;
                    } else
                      diff = 16;

                    if (diff > 15 || diff < 0)
                      return "The car should not be more than 15 years old!";
                    else
                      return null;
                  },
                  onChanged: (value) => setState(() => carYear = value),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon: Icon(Icons.crop_7_5_rounded, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                        borderSide: BorderSide(
                          color: kGreen,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "License Plate Number"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "License Plate Number is Required!"),
                    PatternValidator(r"^[0-9a-zA-Z]{6}$",
                        errorText: "Please enter a valid license plate!"),
                  ]),
                  onChanged: (value) => setState(() => carPlate = value),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.idCard, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                        borderSide: BorderSide(
                          color: kGreen,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Driver License Number"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Driver License Number is Required!"),
                    PatternValidator(r"^(.*[A-Za-z]){1}.[0-9]{11}$",
                        errorText:
                            "Please enter a valid driver license number!"), // 11 but should be 12 numbers
                  ]),
                  onChanged: (value) => setState(() => driverLicense = value),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: FormBuilderDateTimePicker(
                name: 'licenseEnd',
                onChanged: (value) {
                  String mm;
                  if (value!.month < 10) {
                    mm = "0" + value.month.toString();
                  } else {
                    mm = value.month.toString();
                  }
                  String yyyy = value.year.toString();
                  String givenDate = yyyy + '-' + mm;
                  setState(() => licenseEnd = givenDate);
                },
                validator: (value) {
                  var isAfter;
                  if (value != null) {
                    String dd;
                    if (value.day < 10) {
                      dd = "0" + value.day.toString();
                    } else {
                      dd = value.day.toString();
                    }
                    String mm;
                    if (value.month < 10) {
                      mm = "0" + value.month.toString();
                    } else {
                      mm = value.month.toString();
                    }
                    String yyyy = value.year.toString();
                    String givenDate = yyyy + '-' + mm + '-' + dd;
                    var dateNow = new DateTime.now();
                    var givenDateFormat = DateTime.parse(givenDate);
                    isAfter = dateNow.isAfter(givenDateFormat);
                  } else {
                    isAfter = true;
                  }
                  if (isAfter == false)
                    return null;
                  else
                    return ('Your Driver License is expired!');
                },
                inputType: InputType.date,
                decoration: InputDecoration(
                    fillColor: kWhite.withOpacity(0.4),
                    filled: true,
                    prefixIcon: Icon(FontAwesomeIcons.idCard, color: kIconColor),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                      borderSide: BorderSide(
                        color: kGreen,
                      ),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                    ),
                    labelStyle: TextStyle(color: kHintText, fontWeight: FontWeight.bold),
                    labelText: 'License Expiration Date'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: Text(
                'Car Insurance Information',
                style: TextStyle(color: Color(0xFF33415C), fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 1),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    fillColor: kWhite.withOpacity(0.4),
                    filled: true,
                    prefixIcon: Icon(FontAwesomeIcons.carCrash, color: kIconColor),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                      borderSide: BorderSide(
                        color: kGreen,
                      ),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                    ),
                    labelStyle: TextStyle(color: kHintText, fontWeight: FontWeight.bold),
                    labelText: "Insurance Provider"),
                value: insProvider,
                items: insuranceProviders.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: kBlack, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
                dropdownColor: kBackgroundColor,
                validator: RequiredValidator(errorText: "Insurance Provider is Required!"),
                onChanged: (String? value) {
                  setState(() {
                    insProvider = value!;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    fillColor: kWhite.withOpacity(0.4),
                    filled: true,
                    prefixIcon: Icon(FontAwesomeIcons.stream, color: kIconColor),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                      borderSide: BorderSide(
                        color: kGreen,
                      ),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                    ),
                    labelStyle: TextStyle(color: kHintText, fontWeight: FontWeight.bold),
                    labelText: "Coverage Type"),
                value: insType,
                items: <String>[
                  '',
                  'Standard',
                  'Full',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: kBlack, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
                dropdownColor: kBackgroundColor,
                validator: RequiredValidator(errorText: "Coverage Type is Required!"),
                onChanged: (String? value) {
                  setState(() {
                    insType = value!;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: FormBuilderDateTimePicker(
                name: 'insuranceStartDate',
                onChanged: (value) {
                  String mm;
                  if (value!.month < 10) {
                    mm = "0" + value.month.toString();
                  } else {
                    mm = value.month.toString();
                  }
                  String yyyy = value.year.toString();
                  String givenDate = yyyy + '-' + mm;
                  setState(() => insStartDate = givenDate);
                },
                validator: (value) {
                  var isBefore;
                  if (value != null) {
                    String dd;
                    if (value.day < 10) {
                      dd = "0" + value.day.toString();
                    } else {
                      dd = value.day.toString();
                    }
                    String mm;
                    if (value.month < 10) {
                      mm = "0" + value.month.toString();
                    } else {
                      mm = value.month.toString();
                    }
                    String yyyy = value.year.toString();
                    String givenDate = yyyy + '-' + mm + '-' + dd;
                    var dateNow = new DateTime.now();
                    var givenDateFormat = DateTime.parse(givenDate);
                    isBefore = givenDateFormat.isBefore(dateNow);
                  } else {
                    isBefore = false;
                  }
                  if (isBefore == true)
                    return null;
                  else
                    return ('Your Insurance policy cannot start in the future!');
                },
                inputType: InputType.date,
                decoration: InputDecoration(
                    fillColor: kWhite.withOpacity(0.4),
                    filled: true,
                    prefixIcon: Icon(FontAwesomeIcons.calendarPlus, color: kIconColor),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                      borderSide: BorderSide(
                        color: kGreen,
                      ),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                    ),
                    labelStyle: TextStyle(color: kHintText, fontWeight: FontWeight.bold),
                    labelText: 'Insurance Start Date'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: FormBuilderDateTimePicker(
                autovalidateMode: AutovalidateMode.always,
                name: 'insuranceEndDate',
                onChanged: (value) {
                  String mm;
                  if (value!.month < 10) {
                    mm = "0" + value.month.toString();
                  } else {
                    mm = value.month.toString();
                  }
                  String yyyy = value.year.toString();
                  String givenDate = yyyy + '-' + mm;
                  setState(() => insEndDate = givenDate);
                },
                validator: (value) {
                  var isAfter;
                  if (value != null) {
                    String dd;
                    if (value.day < 10) {
                      dd = "0" + value.day.toString();
                    } else {
                      dd = value.day.toString();
                    }
                    String mm;
                    if (value.month < 10) {
                      mm = "0" + value.month.toString();
                    } else {
                      mm = value.month.toString();
                    }
                    String yyyy = value.year.toString();
                    String givenDate = yyyy + '-' + mm + '-' + dd;
                    var dateNow = new DateTime.now();
                    var givenDateFormat = DateTime.parse(givenDate);
                    isAfter = dateNow.isAfter(givenDateFormat);
                  } else {
                    isAfter = true;
                  }
                  if (isAfter == false)
                    return null;
                  else
                    return ('Your Insurance policy is expired!');
                },
                inputType: InputType.date,
                decoration: InputDecoration(
                    fillColor: kWhite.withOpacity(0.4),
                    filled: true,
                    prefixIcon: Icon(FontAwesomeIcons.calendarTimes, color: kIconColor),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                      borderSide: BorderSide(
                        color: kGreen,
                      ),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                    ),
                    labelStyle: TextStyle(color: kHintText, fontWeight: FontWeight.bold),
                    labelText: 'Insurance End Date'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getUserWidget(Size size) {
    return Center(
      child: Form(
        autovalidateMode: AutovalidateMode.always, // Auto Validation Check
        key: userFormkey,

        child: Column(
          children: <Widget>[
            Center(
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.transparent,
                    backgroundImage: _imageFile == null
                        ? AssetImage(
                            "images/chris.jpg",
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
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.signature, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                        borderSide: BorderSide(
                          color: kGreen,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "First Name"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "First Name is Required!"),
                    MinLengthValidator(2,
                        errorText: "First name should be at least 2 characters long!"),
                    MaxLengthValidator(50,
                        errorText: "First name should not exceed 50 characters!"),
                    PatternValidator(r"(^[A-Za-z-,\s']+$)",
                        errorText: "Please enter a valid name!"),
                  ]),
                  onChanged: (value) => setState(() => firstName = value),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.signature, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                        borderSide: BorderSide(
                          color: kGreen,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Last Name"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Last Name is Required!"),
                    MinLengthValidator(2,
                        errorText: "Last name should be at least 2 characters long!"),
                    MaxLengthValidator(50, errorText: "Last name should not exceed 50 characters!"),
                    PatternValidator(r"(^[A-Za-z-,\s']+$)",
                        errorText: "Please enter a valid name!"),
                  ]),
                  onChanged: (value) => setState(() => lastName = value),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.envelope, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                        borderSide: BorderSide(
                          color: kGreen,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Email Address"
                  ),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Email Address is Required!"),
                    EmailValidator(errorText: "Please enter a valid email!"),
                    MaxLengthValidator(50, errorText: "Email should not exceed 50 characters!"),
                  ]),
                  onChanged: (value) => setState(() => email = value),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.phoneAlt, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                        borderSide: BorderSide(
                          color: kGreen,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Phone Number"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Phone Number is Required!"),
                    MaxLengthValidator(10, errorText: "Phone Number should not exceed 10 digits!"),
                    MinLengthValidator(10,
                        errorText: "Phone Number should not be less than 10 digits!"),
                    PatternValidator(r"^[0-9]{10}$",
                        errorText: "Please enter a valid phone number!"),
                  ]),
                  onChanged: (value) => setState(() => phone = value),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: FormBuilderDateTimePicker(
                name: 'dob',
                onChanged: (value) {
                  String dd;
                  String givenDate;
                  if (value != null) {
                    if (value.day < 10) {
                      dd = "0" + value.day.toString();
                    } else {
                      dd = value.day.toString();
                    }
                    String mm;
                    if (value.month < 10) {
                      mm = "0" + value.month.toString();
                    } else {
                      mm = value.month.toString();
                    }
                    String yyyy = value.year.toString();
                    givenDate = yyyy + '-' + mm + '-' + dd;
                  } else
                    givenDate = "";

                  setState(() => dob = givenDate);
                },
                validator: (value) {
                  var age;
                  if (value != null) {
                    String dd;
                    if (value.day < 10) {
                      dd = "0" + value.day.toString();
                    } else {
                      dd = value.day.toString();
                    }
                    String mm;
                    if (value.month < 10) {
                      mm = "0" + value.month.toString();
                    } else {
                      mm = value.month.toString();
                    }
                    String yyyy = value.year.toString();
                    String givenDate = yyyy + '-' + mm + '-' + dd;
                    var dateNow = new DateTime.now();
                    var givenDateFormat = DateTime.parse(givenDate);
                    var diff = dateNow.difference(givenDateFormat);
                    age = ((diff.inDays) / 365).round();
                  } else {
                    age = 0;
                  }
                  if (age > 18)
                    return null;
                  else
                    return ('Age should be over 18 years old');
                },
                inputType: InputType.date,
                decoration: InputDecoration(
                    fillColor: kWhite.withOpacity(0.4),
                    filled: true,
                    prefixIcon: Icon(FontAwesomeIcons.birthdayCake, color: kIconColor),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                      borderSide: BorderSide(
                        color: kGreen,
                      ),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                    ),
                    labelStyle: TextStyle(color: kHintText, fontWeight: FontWeight.bold),
                    labelText: 'Date of Birth'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    fillColor: kWhite.withOpacity(0.4),
                    filled: true,
                    prefixIcon: Icon(FontAwesomeIcons.venusMars, color: kIconColor),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                      borderSide: BorderSide(
                        color: kGreen,
                      ),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                    ),
                    labelStyle: TextStyle(color: kHintText, fontWeight: FontWeight.bold),
                    labelText: "Gender"),
                value: gender,
                items: <String>[
                  '',
                  'Male',
                  'Female',
                  'Other',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: kBlack, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
                dropdownColor: kBackgroundColor,
                validator: RequiredValidator(errorText: "Gender is Required!"),
                onChanged: (String? value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: TextFormField(
                  controller: _pass,
                  obscureText: true,
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.lock, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                        borderSide: BorderSide(
                          color: kGreen,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Password"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Password is Required!"),
                    PatternValidator(r"^(?=.*[0-9])(?=.*[a-zA-Z])([a-z0-9\S]+).{5,50}$",
                        errorText: 'Password must contain one character and a number!')
                  ]),
                  onChanged: (value) => setState(() => password = value),
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: TextFormField(
                  controller: _confirmPass,
                  obscureText: true,
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.lock, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                        borderSide: BorderSide(
                          color: kGreen,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: size.BLOCK_WIDTH * 2),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: size.BLOCK_WIDTH * 1),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Confirm Password"),
                  validator: (val) {
                    if (val!.isEmpty) return 'Confirm Password is Required!';
                    if (val != _pass.text) return 'Passwords do not match!';
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: Text(
                'Are you driving?',
                style: TextStyle(color: Color(0xFF33415C), fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 1),
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
          ],
        ),
      ),
    );
  }

  _getRegisterButtonWidget() {
    return Center(
      child: Form(
          child: RoundedButton(
        color: 0xFF0466CB,
        buttonName: 'Register',
        onClick: () async {
          print(userValidate());
          print(driverValidate());
          Provider.of<User?>(context, listen: false);
          EasyLoading.show(status: "Signing up...");
          String img64;
          if (_imageFile == null) {
            EasyLoading.dismiss();
            EasyLoading.showError("Please upload a profile picture");
            return;
          } else {
            final bytes = Io.File(_imageFile!.path).readAsBytesSync();
            img64 = base64Encode(bytes);
          }
          if (isDriver) {
            if (!userValidate() || !driverValidate()) {
              EasyLoading.dismiss();
              EasyLoading.showError("Please fill up all required fields!");
              return;
            }
          } else {
            if (!userValidate()) {
              EasyLoading.dismiss();
              EasyLoading.showError("Please fill up all required fields!");
              return;
            }
          }

          String uid;
          try {
            uid = (await context.read<Auth>().signup(email.trim(), password.trim()))!;
          } catch (error) {
            EasyLoading.dismiss();
            EasyLoading.showError("Signing up failed, please try again!");
            print(error);
            return;
          }
          print(uid);

          Map<String, dynamic> obj;
          if (isDriver)
            obj = {
              "uid": uid,
              "firstName": firstName.trim(),
              "lastName": lastName.trim(),
              "email": email.trim(),
              "phone": phone.trim(),
              "dob": dob.trim(),
              "gender": gender.trim(),
              "isDriver": isDriver,
              "profilePicData": img64,
              "routingNum": routingNum.trim(),
              "accountNum": accountNum.trim(),
              "make": carBrand.trim(),
              "year": carYear.trim(),
              "color": carColor.trim(),
              "plateNum": carPlate.trim(),
              "provider": insProvider.trim(),
              "coverage": insType.trim(),
              "startDate": insStartDate.trim(),
              "endDate": insEndDate.trim(),
              "licenseNum": driverLicense.trim(),
              "licenseExpDate": licenseEnd.trim(),
            };
          else
            obj = {
              "uid": uid,
              "firstName": firstName.trim(),
              "lastName": lastName.trim(),
              "email": email.trim(),
              "phone": phone.trim(),
              "dob": dob.trim(),
              "gender": gender.trim(),
              "isDriver": isDriver,
              "profilePicData": img64,
            };

          HttpsCallable register =
              FirebaseFunctions.instance.httpsCallable.call('account-registerUser');
          try {
            final result = await register(obj);
            if (result.data == null) {
              EasyLoading.dismiss();
              EasyLoading.showSuccess("Signed Up!");
              await context.read<Auth>().signOut();
              Navigator.popAndPushNamed(context, LoginScreen.id);
              return;
            }
          } catch (e) {
            EasyLoading.dismiss();
            EasyLoading.showInfo("Signing up failed, please try again! try and catch");
            print("error from catch " + e.toString());
          }
        },
      )),
    );
  }
}
