import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/util/CarModels.dart';
import 'package:mobile_app/util/InsuranceProviders.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:image_picker/image_picker.dart';

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

// User Strings
  //var _pickedImage = File("file.txt");
  File _pickedImage;
  final ImagePicker picker = ImagePicker();
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
    for (int i = 0; i < carColors.length; i++) {
      colors.add(carColors[i]['label']);
    }
  }

// Driver Car Insurance Info Strings
  String insProvider = '';
  String insType = '';
  String insStartDate = '';
  String insEndDate = '';

  bool showMultiPane = false;

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  void _remove() {
    setState(() {
      _pickedImage = new File("file.txt");
    });
    Navigator.pop(context);
  }

  void userValidate() {
    if (userFormkey.currentState!.validate()) {
      print(
          "'First Name: $firstName\nLast Name: $lastName\nEmail: $email\nPhone Number: $phone\nDate of Birth: $dob\nGender: $gender\nPassword: $password\nRouting Number: $routingNum\nAccount Number: $accountNum\nCar Brand: $carBrand\nCar Color: $carColor\nCar Year: $carYear\nCar Plate: $carPlate\nDriver License: $driverLicense\nLicense End: $licenseEnd\nInsurance Provider: $insProvider\nInsurance Type: $insType\nInsurance Start Date: $insStartDate\nInsurance End Date: $insEndDate';");
    } else {
      print("User Not Validated");
    }
  }

  void driverValidate() {
    if (driverFormkey.currentState!.validate()) {
      print(
          "'First Name: $firstName\nLast Name: $lastName\nEmail: $email\nPhone Number: $phone\nDate of Birth: $dob\nPassword: $password';");
    } else {
      print("Driver Not Validated");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                Center(child: _getUserWidget(size, context)),
                showMultiPane ? _getDriverWidget(size, context) : Container(),
                Center(child: _getRegisterButtonWidget(size, context)),
              ],
            ),
          )),
    );
  }

  _getDriverWidget(Size size, BuildContext context) {
    return Center(
      child: Form(
        autovalidateMode: AutovalidateMode.always, // Auto Validation Check
        key: driverFormkey,

        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Text(
                'Bank Information',
                style: TextStyle(
                    color: Color(0xFF33415C), fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.moneyCheckAlt,
                          color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Routing Number"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Routing Number is Required!"),
                    MinLengthValidator(9,
                        errorText: "Please enter a valid Routing Number!"),
                    MaxLengthValidator(9,
                        errorText: "Please enter a valid Routing Number!")
                  ]),
                  onChanged: (value) => setState(() => routingNum = value),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon:
                          Icon(FontAwesomeIcons.moneyCheck, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Account Number"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Account Number is Required!"),
                    MinLengthValidator(9,
                        errorText: "Please enter a valid Account Number!"),
                    MaxLengthValidator(12,
                        errorText: "Please enter a valid Account Number!")
                  ]),
                  onChanged: (value) => setState(() => accountNum = value),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Text(
                'Car Information',
                style: TextStyle(
                    color: Color(0xFF33415C), fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: DropdownSearch<String>(
                  autoValidateMode: AutovalidateMode.always,
                  // validator: (value) {},
                  mode: Mode.BOTTOM_SHEET,
                  showSearchBox: true,
                  validator:
                      RequiredValidator(errorText: "Car Brand is required!"),
                  dropdownSearchDecoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.car, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      labelStyle: TextStyle(color: kHintText),
                      labelText: "Car Brand"),
                  items: carModels,
                  onChanged: (value) => setState(() => carBrand = value!),
                  selectedItem: ""),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0, bottom: 25),
              child: DropdownSearch<String>(
                  autoValidateMode: AutovalidateMode.always,
                  mode: Mode.BOTTOM_SHEET,
                  showSearchBox: true,
                  validator:
                      RequiredValidator(errorText: "Car Color is required!"),
                  dropdownSearchDecoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon:
                          Icon(FontAwesomeIcons.palette, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
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
              padding: EdgeInsets.only(top: 25.0),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon:
                          Icon(FontAwesomeIcons.calendar, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Year of Manufacture"),
                  validator: (value) {
                    int diff;
                    if (value != null) {
                      int currentYear = DateTime.now().year;
                      int val;
                      try {
                        val = int.parse(value);
                      } catch (e) {
                        print("error from the catch: $e");
                        val = 0;
                      }
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
              padding: EdgeInsets.only(top: 25.0),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon:
                          Icon(Icons.crop_7_5_rounded, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "License Plate Number"),
                  validator: MultiValidator([
                    RequiredValidator(
                        errorText: "License Plate Number is Required!"),
                    PatternValidator(r"^[0-9a-zA-Z]{6}$",
                        errorText: "Please enter a valid license plate!"),
                  ]),
                  onChanged: (value) => setState(() => carPlate = value),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon:
                          Icon(FontAwesomeIcons.idCard, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Driver License Number"),
                  validator: MultiValidator([
                    RequiredValidator(
                        errorText: "Driver License Number is Required!"),
                    PatternValidator(r"^(.*[A-Za-z]){1}.[0-9]{11}$",
                        errorText:
                            "Please enter a valid driver river license number!"), // 11 but should be 12 numbers
                  ]),
                  onChanged: (value) => setState(() => driverLicense = value),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: FormBuilderDateTimePicker(
                name: 'licenseEnd',
                onChanged: (value) {
                  // String dd;
                  // if (value!.day < 10) {
                  //   dd = "0" + value.day.toString();
                  // } else {
                  //   dd = value.day.toString();
                  // }
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
                    // var now = new DateTime();
                    print(givenDate);
                    var dateNow = new DateTime.now();
                    print(dateNow);
                    //var givenDate = "1969-07-20";
                    var givenDateFormat = DateTime.parse(givenDate);
                    var diff = dateNow.difference(givenDateFormat);
                    age = ((diff.inDays) / 31).round();
                    print("age = $age");
                  } else {
                    age = 0;
                  }
                  if (age < 0)
                    return null;
                  else
                    return ('Your Driver License is expired!');
                },
                inputType: InputType.date,
                decoration: InputDecoration(
                    fillColor: kWhite.withOpacity(0.4),
                    filled: true,
                    prefixIcon:
                        Icon(FontAwesomeIcons.idCard, color: kIconColor),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: 5),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: 5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: 5),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: 5),
                    ),
                    labelStyle: TextStyle(
                        color: kHintText, fontWeight: FontWeight.bold),
                    labelText: 'License Expiration Date'),
                //initialTime: TimeOfDay(hour: 8, minute: 0),
                // initialValue: DateTime.now(),
                // enabled:! true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Text(
                'Car Insurance Information',
                style: TextStyle(
                    color: Color(0xFF33415C), fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    fillColor: kWhite.withOpacity(0.4),
                    filled: true,
                    prefixIcon:
                        Icon(FontAwesomeIcons.carCrash, color: kIconColor),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: 5),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: 5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: 5),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: 5),
                    ),
                    labelStyle: TextStyle(
                        color: kHintText, fontWeight: FontWeight.bold),
                    labelText: "Insurance Provider"),
                value: insProvider,
                items: insuranceProviders
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style:
                          TextStyle(color: kBlack, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
                dropdownColor: kBackgroundColor,
                validator: RequiredValidator(
                    errorText: "Insurance Provider is Required!"),
                onChanged: (String? value) {
                  setState(() {
                    insProvider = value!;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    fillColor: kWhite.withOpacity(0.4),
                    filled: true,
                    prefixIcon:
                        Icon(FontAwesomeIcons.stream, color: kIconColor),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: 5),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: 5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: 5),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: 5),
                    ),
                    labelStyle: TextStyle(
                        color: kHintText, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(color: kBlack, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
                dropdownColor: kBackgroundColor,
                validator:
                    RequiredValidator(errorText: "Coverage Type is Required!"),
                onChanged: (String? value) {
                  setState(() {
                    insType = value!;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: FormBuilderDateTimePicker(
                name: 'insuranceStartDate',
                onChanged: (value) {
                  // String dd;
                  // if (value!.day < 10) {
                  //   dd = "0" + value.day.toString();
                  // } else {
                  //   dd = value.day.toString();
                  // }
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
                    // var now = new DateTime();
                    print(givenDate);
                    var dateNow = new DateTime.now();
                    print(dateNow);
                    //var givenDate = "1969-07-20";
                    var givenDateFormat = DateTime.parse(givenDate);
                    var diff = dateNow.difference(givenDateFormat);
                    age = ((diff.inDays) / 31).round();
                    print("age = $age");
                  } else {
                    age = 0;
                  }
                  if (age < 0)
                    return null;
                  else
                    return ('Your Insurance policy cannot start in the future!');
                },
                inputType: InputType.date,
                decoration: InputDecoration(
                    fillColor: kWhite.withOpacity(0.4),
                    filled: true,
                    prefixIcon:
                        Icon(FontAwesomeIcons.calendarPlus, color: kIconColor),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: 5),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: 5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: 5),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: 5),
                    ),
                    labelStyle: TextStyle(
                        color: kHintText, fontWeight: FontWeight.bold),
                    labelText: 'Insurance Start Date'),
                //initialTime: TimeOfDay(hour: 8, minute: 0),
                // initialValue: DateTime.now(),
                // enabled:! true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: FormBuilderDateTimePicker(
                name: 'insuranceEndDate',
                onChanged: (value) {
                  // String dd;
                  // if (value!.day < 10) {
                  //   dd = "0" + value.day.toString();
                  // } else {
                  //   dd = value.day.toString();
                  // }
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
                    // var now = new DateTime();
                    print(givenDate);
                    var dateNow = new DateTime.now();
                    print(dateNow);
                    //var givenDate = "1969-07-20";
                    var givenDateFormat = DateTime.parse(givenDate);
                    var diff = dateNow.difference(givenDateFormat);
                    age = ((diff.inDays) / 31).round();
                    print("age = $age");
                  } else {
                    age = 0;
                  }
                  if (age < 0)
                    return null;
                  else
                    return ('Your Insurance policy expired!');
                },
                inputType: InputType.date,
                decoration: InputDecoration(
                    fillColor: kWhite.withOpacity(0.4),
                    filled: true,
                    prefixIcon:
                        Icon(FontAwesomeIcons.calendarTimes, color: kIconColor),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: 5),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: 5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: 5),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: 5),
                    ),
                    labelStyle: TextStyle(
                        color: kHintText, fontWeight: FontWeight.bold),
                    labelText: 'Insurance End Date'),
                //initialTime: TimeOfDay(hour: 8, minute: 0),
                // initialValue: DateTime.now(),
                // enabled:! true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getUserWidget(Size size, BuildContext context) {
    return Center(
      child: Form(
        autovalidateMode: AutovalidateMode.always, // Auto Validation Check
        key: userFormkey,

        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: CircleAvatar(
                    radius: 71,
                    backgroundColor: kBlack.withOpacity(.5),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: kBlack.withOpacity(.5),
                      backgroundImage:
                          _pickedImage == null ? null : FileImage(_pickedImage),
                    ),
                  ),
                ),
                Positioned(
                    top: 120,
                    left: 110,
                    child: RawMaterialButton(
                      elevation: 10,
                      fillColor: kBlack.withOpacity(.5),
                      child: Icon(Icons.add_a_photo),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Choose option',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: kBlack.withOpacity(.5)),
                                ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      InkWell(
                                        onTap: _pickImageCamera,
                                        splashColor: Colors.purpleAccent,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.camera,
                                                color: Colors.purpleAccent,
                                              ),
                                            ),
                                            Text(
                                              'Camera',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      kBlack.withOpacity(.5)),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: _pickImageGallery,
                                        splashColor: Colors.purpleAccent,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.image,
                                                color: Colors.purpleAccent,
                                              ),
                                            ),
                                            Text(
                                              'Gallery',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      kBlack.withOpacity(.5)),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: _remove,
                                        splashColor: Colors.purpleAccent,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.remove_circle,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Text(
                                              'Remove',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ))
              ],
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: 25.0),
            //   child: FormBuilder(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: <Widget>[
            //         FormBuilderImagePicker(
            //           name: 'photos',
            //           decoration:
            //               const InputDecoration(labelText: 'Pick Photos'),
            //           maxImages: 1,
            //         ),
            //         const SizedBox(height: 15),
            //         RaisedButton(onPressed: () {
            //           if (_formKey.currentState.saveAndValidate()) {
            //             print(_formKey.currentState.value);
            //           }
            //         })
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon:
                          Icon(FontAwesomeIcons.signature, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "First Name"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "First Name is Required!"),
                    MinLengthValidator(2,
                        errorText:
                            "First name should be at least 2 characters long!"),
                    MaxLengthValidator(50,
                        errorText:
                            "First name should not exceed 50 characters!"),
                    PatternValidator(r"(^[A-Za-z-,\s']+$)",
                        errorText: "Please enter a valid name!"),
                  ]),
                  onChanged: (value) => setState(() => firstName = value),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon:
                          Icon(FontAwesomeIcons.signature, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Last Name"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Last Name is Required!"),
                    MinLengthValidator(2,
                        errorText:
                            "Last name should be at least 2 characters long!"),
                    MaxLengthValidator(50,
                        errorText:
                            "Last name should not exceed 50 characters!"),
                    PatternValidator(r"(^[A-Za-z-,\s']+$)",
                        errorText: "Please enter a valid name!"),
                  ]),
                  onChanged: (value) => setState(() => lastName = value),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon:
                          Icon(FontAwesomeIcons.envelope, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Email Address"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Email Address is Required!"),
                    EmailValidator(errorText: "Please enter a valid email!"),
                    MaxLengthValidator(50,
                        errorText: "Email should not exceed 50 characters!"),
                  ]),
                  onChanged: (value) => setState(() => email = value),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon:
                          Icon(FontAwesomeIcons.phoneAlt, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Phone Number"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Phone Number is Required!"),
                    MaxLengthValidator(10,
                        errorText: "Phone Number should not exceed 10 digits!"),
                    MinLengthValidator(10,
                        errorText:
                            "Phone Number should not be less than 10 digits!"),
                    PatternValidator(r"^[0-9]{10}$",
                        errorText: "Please enter a valid phone number!"),
                  ]),
                  onChanged: (value) => setState(() => phone = value),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: FormBuilderDateTimePicker(
                name: 'dob',
                onChanged: (value) {
                  String dd;
                  if (value!.day < 10) {
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
                    // var now = new DateTime();
                    print(givenDate);
                    var dateNow = new DateTime.now();
                    print(dateNow);
                    //var givenDate = "1969-07-20";
                    var givenDateFormat = DateTime.parse(givenDate);
                    var diff = dateNow.difference(givenDateFormat);
                    age = ((diff.inDays) / 365).round();
                    print("age = $age");
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
                    prefixIcon:
                        Icon(FontAwesomeIcons.birthdayCake, color: kIconColor),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: 5),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: 5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: 5),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: 5),
                    ),
                    labelStyle: TextStyle(
                        color: kHintText, fontWeight: FontWeight.bold),
                    labelText: 'Date of Birth'),

                //initialTime: TimeOfDay(hour: 8, minute: 0),
                // initialValue: DateTime.now(),
                // enabled: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    fillColor: kWhite.withOpacity(0.4),
                    filled: true,
                    prefixIcon:
                        Icon(FontAwesomeIcons.venusMars, color: kIconColor),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: 5),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: 5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kGreen, width: 5),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kRed, width: 5),
                    ),
                    labelStyle: TextStyle(
                        color: kHintText, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(color: kBlack, fontWeight: FontWeight.bold),
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
              padding: EdgeInsets.only(top: 25.0),
              child: TextFormField(
                  controller: _pass,
                  obscureText: true,
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon:
                          Icon(FontAwesomeIcons.lock, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      hintStyle: TextStyle(color: kHintText),
                      hintText: "Password"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Password is Required!"),
                    PatternValidator(
                        r"^(?=.*\d)(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z]).{6,50}$",
                        errorText:
                            'Password must contain one symbol and number!')
                  ]),
                  onChanged: (value) => setState(() => password = value),
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: TextFormField(
                  controller: _confirmPass,
                  obscureText: true,
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon:
                          Icon(FontAwesomeIcons.lock, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kGreen, width: 5),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kRed, width: 5),
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
              padding: EdgeInsets.only(top: 25.0),
              child: Text(
                'Are you driving?',
                style: TextStyle(
                    color: Color(0xFF33415C), fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: FlutterSwitch(
                width: 100.0,
                height: 45.0,
                toggleSize: 35.0,
                value: showMultiPane,
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
                    showMultiPane = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getRegisterButtonWidget(Size size, BuildContext context) {
    return Center(
      child: Form(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: ElevatedButton(
                onPressed: () {
                  userValidate();
                  driverValidate();
                },
                child: Text("Register"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
