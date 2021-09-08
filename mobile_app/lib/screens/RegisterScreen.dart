import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/pallete.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RegisterScreen extends StatefulWidget {
  static const id = 'registerScreen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> userFormkey = GlobalKey<FormState>();
  GlobalKey<FormState> driverFormkey = GlobalKey<FormState>();

  TextEditingController _pass = TextEditingController();
  TextEditingController _confirmPass = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  _selectBirthDate(BuildContext context) async {
    print('Show Popup Calendar');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String dob =
            "${picked.toLocal().month}/${picked.toLocal().day}/${picked.toLocal().year}"; //MM/DD/YYY
        _dateController.text = dob;
        print(dob);
        print(_dateController.text);
      });
  }

  _selectLicenseEndDate(BuildContext context) async {
    print('Show Popup Calendar');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String licenseEnd =
            "${picked.toLocal().month}/${picked.toLocal().day}/${picked.toLocal().year}"; //MM/DD/YYY
        _dateController.text = licenseEnd;
        print(licenseEnd);
      });
  }

  _selectInsStartDate(BuildContext context) async {
    print('Show Popup Calendar');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String insStartDate =
            "${picked.toLocal().month}/${picked.toLocal().day}/${picked.toLocal().year}"; //MM/DD/YYY
        _dateController.text = insStartDate;
        print(insStartDate);
      });
  }

  _selectInsEndDate(BuildContext context) async {
    print('Show Popup Calendar');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String insEndDate =
            "${picked.toLocal().month}/${picked.toLocal().day}/${picked.toLocal().year}"; //MM/DD/YYY
        _dateController.text = insEndDate;
        print(insEndDate);
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

// Driver Car Insurance Info Strings
  String insProvider = '';
  String insType = '';
  String insStartDate = '';
  String insEndDate = '';

  bool showMultiPane = false;

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
    return Scaffold(
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
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Column(
            children: [
              Center(child: _getUserWidget(size, context)),
              showMultiPane ? _getDriverWidget(size, context) : Container(),
              Center(child: _getRegisterButtonWidget(size, context)),
            ],
          ),
        ));
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
              child: FormBuilderDateTimePicker(
                name: 'date',
                onChanged: (value) => setState(() => dob = value.toString()),
                inputType: InputType.date,
                decoration: InputDecoration(
                  labelText: 'Appointment Time',
                ),
                initialTime: TimeOfDay(hour: 8, minute: 0),
                // initialValue: DateTime.now(),
                // enabled: true,
              ),
            ),
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
              child: DropdownButtonFormField(
                decoration: InputDecoration(
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
                    labelStyle: TextStyle(
                        color: kHintText, fontWeight: FontWeight.bold),
                    labelText: "Car Brand"),
                value: carBrand,
                items: <String>[
                  '',
                  'Nissan',
                  'Jeep',
                  'Ford',
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
                    RequiredValidator(errorText: "Car Brand is Required!"),
                onChanged: (String? value) {
                  setState(() {
                    carBrand = value!;
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
                    labelStyle: TextStyle(
                        color: kHintText, fontWeight: FontWeight.bold),
                    labelText: "Car Color"),
                value: carColor,
                items: <String>[
                  '',
                  'Red',
                  'Green',
                  'Blue',
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
                    RequiredValidator(errorText: "Car Color is Required!"),
                onChanged: (String? value) {
                  setState(() {
                    carColor = value!;
                  });
                },
              ),
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
                  validator: RequiredValidator(
                      errorText: "Year of Manufacture is Required!"),
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
                  validator: RequiredValidator(
                      errorText: "License Plate Number is Required!"),
                  onChanged: (value) => setState(() => carPlate = value),
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
                          Icon(FontAwesomeIcons.idBadge, color: kIconColor),
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
                  validator: RequiredValidator(
                      errorText: "Driver License Number is Required!"),
                  onChanged: (value) => setState(() => driverLicense = value),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: InkWell(
                onTap: () {
                  print("User tapped License End Date field");
                  _selectLicenseEndDate(context);
                },
                child: Container(
                  child: IgnorePointer(
                    child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                            fillColor: kWhite.withOpacity(0.4),
                            filled: true,
                            prefixIcon: Icon(FontAwesomeIcons.calendarTimes,
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
                            hintText: "License End Date"),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "License End Date is Required!"),
                        ]),
                        onChanged: (value) =>
                            setState(() => licenseEnd = value),
                        textInputAction: TextInputAction.next,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
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
                items: <String>[
                  '',
                  'Allstate',
                  'State Farm',
                  'Geico',
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
              child: InkWell(
                onTap: () {
                  print("User tapped Insurance Start Date field");
                  _selectInsStartDate(context);
                },
                child: Container(
                  child: IgnorePointer(
                    child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                            fillColor: kWhite.withOpacity(0.4),
                            filled: true,
                            prefixIcon: Icon(FontAwesomeIcons.calendarPlus,
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
                            hintText: "Insurance Start Date"),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "Insurance Start Date is Required!"),
                        ]),
                        onChanged: (value) =>
                            setState(() => insStartDate = value),
                        textInputAction: TextInputAction.next,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: InkWell(
                onTap: () {
                  print("User tapped Insurance End Date field");
                  _selectInsEndDate(context);
                },
                child: Container(
                  child: IgnorePointer(
                    child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                            fillColor: kWhite.withOpacity(0.4),
                            filled: true,
                            prefixIcon: Icon(FontAwesomeIcons.calendarMinus,
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
                            hintText: "Insurance End Date"),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "Insurance Start End is Required!"),
                        ]),
                        onChanged: (value) =>
                            setState(() => insEndDate = value),
                        textInputAction: TextInputAction.next,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
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
            Padding(
              padding: EdgeInsets.only(top: 0),
              child: CircleAvatar(
                radius: size.width * 0.14,
                backgroundColor: Colors.transparent,
                child: Image(
                  image: AssetImage('images/splashIcon.png'),
                  color: kWhite,
                ),
              ),
            ),
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
            // Padding(
            //   padding: EdgeInsets.only(top: 25.0),
            //   child: InkWell(
            //     onTap: () {
            //       print("User tapped Date of Birth field");
            //       _selectBirthDate(context);
            //     },
            //     child: Container(
            //       child: IgnorePointer(
            //         child: TextFormField(
            //             controller: _dateController,
            //             decoration: InputDecoration(
            //                 fillColor: kWhite.withOpacity(0.4),
            //                 filled: true,
            //                 prefixIcon: Icon(FontAwesomeIcons.birthdayCake,
            //                     color: kIconColor),
            //                 enabledBorder: UnderlineInputBorder(
            //                   borderRadius: BorderRadius.circular(10),
            //                   borderSide: BorderSide(color: kGreen, width: 5),
            //                 ),
            //                 errorBorder: UnderlineInputBorder(
            //                   borderRadius: BorderRadius.circular(10),
            //                   borderSide: BorderSide(color: kRed, width: 5),
            //                 ),
            //                 focusedBorder: UnderlineInputBorder(
            //                   borderRadius: BorderRadius.circular(10),
            //                   borderSide: BorderSide(color: kGreen, width: 5),
            //                 ),
            //                 focusedErrorBorder: UnderlineInputBorder(
            //                   borderRadius: BorderRadius.circular(10),
            //                   borderSide: BorderSide(color: kRed, width: 5),
            //                 ),
            //                 hintStyle: TextStyle(color: kHintText),
            //                 hintText: "Date of Birth"),
            //             validator: MultiValidator([
            //               RequiredValidator(
            //                   errorText: "Date of Birth is Required!"),
            //               //PatternValidator("^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$", errorText: "errorText"),
            //             ]),
            //             onChanged: (value) => setState(() => dob = value),
            //             textInputAction: TextInputAction.done,
            //             style: TextStyle(fontWeight: FontWeight.bold)),
            //       ),
            //     ),
            //   ),
            // ),
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
                    // MaxLengthValidator(50,
                    //     errorText:
                    //         "Password should not exceed 50 characters!"),
                    // MinLengthValidator(6,
                    //     errorText:
                    //         'Password must be at least 8 digits long!'),
                    PatternValidator(
                        r"^(?=.*\d)(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z]).{6,50}$",
                        // ^(?=.[0-9])(?=.[a-zA-Z])(?=\S+$).{6,50}$ // Updated one not working...
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
