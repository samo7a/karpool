import 'package:cloud_functions/cloud_functions.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mobile_app/util/CarModels.dart';
import 'package:mobile_app/util/InsuranceProviders.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/rounded-button.dart';
import '../SplashScreen.dart';
import 'package:mobile_app/models/User.dart';

class DriverApplication extends StatefulWidget {
  static const String id = 'driverApplication';
  const DriverApplication({Key? key}) : super(key: key);

  @override
  _DriverApplicationState createState() => _DriverApplicationState();
}

class _DriverApplicationState extends State<DriverApplication> {
  GlobalKey<FormState> driverFormkey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
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
  String insProvider = '';
  String insType = '';
  String insStartDate = '';
  String insEndDate = '';

  bool driverValidate() {
    if (driverFormkey.currentState!.validate())
      return true;
    else
      return false;
  }

  initState() {
    super.initState();
    for (int i = 0; i < carColors.length; i++) {
      colors.add(carColors[i]['label']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    Size size = Size(Context: context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: kDashboardColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: kWhite,
              ),
            ),
            title: Text(
              'Driver Application',
              style: kBodyText,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                vertical: size.BLOCK_HEIGHT * 2, horizontal: size.BLOCK_WIDTH * 3.5),
            child: Column(
              children: [
                Center(
                  child: _getDriverWidget(size),
                ),
                Center(
                  child: _getRegisterButtonWidget(user),
                ),
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
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: "Routing Number"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Routing Number is Required!"),
                    MinLengthValidator(9, errorText: "Please enter a valid Routing Number!"),
                    MaxLengthValidator(9, errorText: "Please enter a valid Routing Number!")
                  ]),
                  onChanged: (value) => setState(() => routingNum = value),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: "Account Number"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Account Number is Required!"),
                    MinLengthValidator(9, errorText: "Please enter a valid Account Number!"),
                    MaxLengthValidator(12, errorText: "Please enter a valid Account Number!")
                  ]),
                  onChanged: (value) => setState(() => accountNum = value),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: Text(
                'Car Information',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 1),
              child: DropdownSearch<String>(
                autoValidateMode: AutovalidateMode.always,
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
                  labelStyle: TextStyle(color: Colors.white),
                  labelText: "Car Brand",
                ),
                items: carModels,
                onChanged: (value) => setState(() => carBrand = value!),
                selectedItem: "",
              ),
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
                      labelStyle: TextStyle(color: Colors.white),
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
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    hintText: "Year of Manufacture",
                  ),
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
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: "License Plate Number"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "License Plate Number is Required!"),
                    PatternValidator(r"^[0-9a-zA-Z]{6}$",
                        errorText: "Please enter a valid license plate!"),
                  ]),
                  onChanged: (value) => setState(() => carPlate = value),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: "Driver License Number"),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Driver License Number is Required!"),
                    PatternValidator(
                      r"^(.*[A-Za-z]){1}.[0-9]{11}$",
                      errorText: "Please enter a valid driver license number!",
                    ), // 11 but should be 12 numbers
                  ]),
                  onChanged: (value) => setState(() => driverLicense = value),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: FormBuilderDateTimePicker(
                name: 'licenseEnd',
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
                  setState(() => licenseEnd = givenDate);
                  print(licenseEnd);
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
                    labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    labelText: 'License Expiration Date'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
              child: Text(
                'Car Insurance Information',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                    labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                    labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                    labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                    labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    labelText: 'Insurance End Date'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getRegisterButtonWidget(User user) {
    return Center(
      child: Form(
          child: RoundedButton(
        color: 0xFF0466CB,
        buttonName: 'Apply',
        onClick: () async {
          EasyLoading.show(status: "Working on it");

          if (!driverValidate()) {
            EasyLoading.dismiss();
            EasyLoading.showError("Please fill up all required fields!");
            return;
          }

          Map<String, dynamic> obj = {
            "role": "Driver",
            "driverInfo": {
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
            }
          };
          print(obj.toString());
          HttpsCallable addRole = FirebaseFunctions.instance.httpsCallable.call('account-addRole');
          try {
            final result = await addRole(obj);
            if (result.data == null) {
              EasyLoading.dismiss();
              EasyLoading.showSuccess("Congratulations!");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => SplashScreen(),
                ),
                (Route<dynamic> route) => false,
              );
              return;
            }
          } catch (e) {
            print("error adding role: " + e.toString());
            EasyLoading.dismiss();
            EasyLoading.showError("Something went wrong!");
            Navigator.pop(context);
            return;
          }
        },
      )),
    );
  }
}
