import 'package:cloud_functions/cloud_functions.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mobile_app/util/InsuranceProviders.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/CarModels.dart';
import 'package:mobile_app/util/Size.dart';

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({Key? key}) : super(key: key);
  static const String id = "vehicleInfo";
  @override
  _VehicleInfoScreen createState() => _VehicleInfoScreen();
}

class _VehicleInfoScreen extends State<VehicleInfoScreen> {
  GlobalKey<FormState> carYearKey = GlobalKey<FormState>();
  GlobalKey<FormState> plateKey = GlobalKey<FormState>();
  GlobalKey<FormState> insStartKey = GlobalKey<FormState>();
  GlobalKey<FormState> insEndKey = GlobalKey<FormState>();

  // Original Driver Car Info Strings
  String initCarBrand = 'Nissan';
  String initCarColor = 'Black';
  String initInsProvider = 'Progressive';
  String initInsType = 'Standard';
  String initCarYear = '2015';
  String initCarPlate = 'FH12HF';
  String initInsStartDate = '01/01/2021';
  String initInsEndDate = '01/01/2022';
  // DateTime initLicenseEnd = DateTime(2021, 12, 31);

  // New Driver Car Info Strings
  String newCarBrand = '';
  String newCarColor = '';
  String newCarYear = '';
  String newCarPlate = '';
  String newInsProvider = '';
  String newInsType = '';
  String newInsStartDate = '';
  String newInsEndDate = '';

  List<String> insuranceProviders = providers;
  List<String> carModels = cars;
  List<String> colors = [];

  initState() {
    super.initState();
    for (int i = 0; i < carColors.length; i++) {
      colors.add(carColors[i]['label']);
    }
  }

  bool validateInput() {
    bool res1 = false;
    bool res2 = false;
    bool res3 = false;
    bool res4 = false;

    if (carYearKey.currentState!.validate()) res1 = true;

    if (plateKey.currentState!.validate()) res2 = true;

    if (insStartKey.currentState!.validate()) res3 = true;

    if (insEndKey.currentState!.validate()) res4 = true;

    if (res1 && res2 && res3 && res4)
      return true;
    else
      return false;
  }

  // void changeCarInfo() async {
  //   if (!validateInput()) {
  //     EasyLoading.showError("Please fix your input and try again.");
  //     return;
  //   }

  //   if (newCarBrand == '') newCarBrand = initCarBrand;
  //   if (newCarColor == '') newCarColor = initCarColor;
  //   if (newCarYear == '') newCarYear = initCarYear;
  //   if (newCarPlate == '') newCarPlate = initCarPlate;
  //   if (newInsProvider == '') newInsProvider = initInsProvider;
  //   if (newInsType == '') newInsType = initInsType;
  //   if (newInsStartDate == '') newInsStartDate = initInsStartDate;
  //   if (newInsEndDate == '') newInsEndDate = initInsEndDate;

  //   // TODO: validate new info
  //   HttpsCallable changeVehicleInfo =
  //       FirebaseFunctions.instance.httpsCallable("account-editCarInfo");
  //   Map<String, dynamic> obj = {
  //     "uid": uid,
  //     "make": newCarBrand.trim(),
  //     "year": newCarYear.trim(),
  //     "color": newCarColor.trim(),
  //     "plateNum": newCarPlate.trim(),
  //     "provider": newInsProvider.trim(),
  //     "coverage": newInsType.trim(),
  //     "startDate": newInsStartDate.trim(),
  //     "endDate": newInsEndDate.trim(),
  //   };
  //   try {
  //     print("inside the try");
  //     final result = await changeVehicleInfo(obj);
  //     final data = result.data;
  //     print(result);
  //     print(data);
  //     EasyLoading.dismiss();
  //     EasyLoading.showSuccess("Vehicle information has been updated!");
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     EasyLoading.showError("Error updating the vehicle information.");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return Scaffold(
      backgroundColor: Color(0xff33415C),
      appBar: AppBar(
        backgroundColor: Color(0xff33415C),
        title: Text("Vehicle Information"),
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
        padding: EdgeInsets.symmetric(
            vertical: size.BLOCK_HEIGHT * 2,
            horizontal: size.BLOCK_WIDTH * 3.5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT),
              ),
              Text(
                'Current Car Brand',
                style: TextStyle(
                  color: kWhite,
                  fontSize: size.FONT_SIZE * 15,
                ),
                textAlign: TextAlign.start,
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT),
              ),
              TextFormField(
                enabled: false,
                initialValue: initCarBrand,
                decoration: InputDecoration(
                  fillColor: kWhite.withOpacity(0.4),
                  filled: true,
                  prefixIcon: Icon(FontAwesomeIcons.car, color: kIconColor),
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
              ),
              DropdownSearch<String>(
                  autoValidateMode: AutovalidateMode.always,
                  mode: Mode.BOTTOM_SHEET,
                  showSearchBox: true,
                  dropdownSearchDecoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.car, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                        borderSide: BorderSide(
                          color: kGreen,
                        ),
                      ),
                      labelStyle: TextStyle(color: kIconColor),
                      labelText: "New Car Brand"),
                  items: carModels,
                  onChanged: (value) => setState(() => newCarBrand = value!),
                  selectedItem: ""),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2.5),
              ),
              Text(
                'Current Car Color',
                style: TextStyle(
                  color: kWhite,
                  fontSize: size.FONT_SIZE * 15,
                ),
                textAlign: TextAlign.start,
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT),
              ),
              TextFormField(
                enabled: false,
                initialValue: initCarColor,
                decoration: InputDecoration(
                  fillColor: kWhite.withOpacity(0.4),
                  filled: true,
                  prefixIcon: Icon(FontAwesomeIcons.palette, color: kIconColor),
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
              ),
              DropdownSearch<String>(
                autoValidateMode: AutovalidateMode.always,
                mode: Mode.BOTTOM_SHEET,
                showSearchBox: true,
                dropdownSearchDecoration: InputDecoration(
                    fillColor: kWhite.withOpacity(0.4),
                    filled: true,
                    prefixIcon:
                        Icon(FontAwesomeIcons.palette, color: kIconColor),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                      borderSide: BorderSide(
                        color: kGreen,
                      ),
                    ),
                    labelStyle: TextStyle(color: kIconColor),
                    labelText: "New Car Color"),
                items: colors,
                onChanged: (value) {
                  setState(() {
                    newCarColor = value!;
                  });
                },
                selectedItem: "",
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2.5),
              ),
              Text(
                'Current Year of Manufacture',
                style: TextStyle(
                  color: kWhite,
                  fontSize: size.FONT_SIZE * 15,
                ),
                textAlign: TextAlign.start,
              ),
              Form(
                key: carYearKey,
                autovalidateMode: AutovalidateMode.always,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: size.BLOCK_HEIGHT,
                  ),
                  child: TextFormField(
                    initialValue: initCarYear,
                    decoration: InputDecoration(
                        fillColor: kWhite.withOpacity(0.4),
                        filled: true,
                        prefixIcon:
                            Icon(FontAwesomeIcons.calendar, color: kIconColor),
                        enabledBorder: UnderlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                          borderSide: BorderSide(
                            color: kGreen,
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: kRed, width: size.BLOCK_WIDTH * 1),
                        ),
                        hintStyle: TextStyle(
                          color: kIconColor,
                        ),
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
                        return "The car should be no more than 15 years old!";
                      else
                        return null;
                    },
                    onChanged: (value) => setState(() => newCarYear = value),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
              ),
              Text(
                'Current License Plate Number',
                style: TextStyle(
                  color: kWhite,
                  fontSize: size.FONT_SIZE * 15,
                ),
                textAlign: TextAlign.start,
              ),
              Form(
                key: plateKey,
                autovalidateMode: AutovalidateMode.always,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: size.BLOCK_HEIGHT,
                  ),
                  child: TextFormField(
                      initialValue: initCarPlate,
                      decoration: InputDecoration(
                          fillColor: kWhite.withOpacity(0.4),
                          filled: true,
                          prefixIcon:
                              Icon(Icons.crop_7_5_rounded, color: kIconColor),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                            borderSide: BorderSide(
                              color: kGreen,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: kRed, width: size.BLOCK_WIDTH * 1),
                          ),
                          hintStyle: TextStyle(color: kIconColor),
                          hintText: "License Plate Number"),
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: "License Plate Number is Required!"),
                        PatternValidator(r"^[0-9a-zA-Z]{6}$",
                            errorText: "Please enter a valid license plate!"),
                      ]),
                      onChanged: (value) => setState(() => newCarPlate = value),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
              ),
              Text(
                'Current Insurance Provider',
                style: TextStyle(
                  color: kWhite,
                  fontSize: size.FONT_SIZE * 15,
                ),
                textAlign: TextAlign.start,
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT),
              ),
              TextFormField(
                enabled: false,
                initialValue: initInsProvider,
                decoration: InputDecoration(
                  fillColor: kWhite.withOpacity(0.4),
                  filled: true,
                  prefixIcon:
                      Icon(FontAwesomeIcons.carCrash, color: kIconColor),
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon:
                          Icon(FontAwesomeIcons.carCrash, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                        borderSide: BorderSide(
                          color: kGreen,
                        ),
                      ),
                      labelStyle: TextStyle(
                          color: kIconColor, fontWeight: FontWeight.bold),
                      labelText: "New Insurance Provider"),
                  value: newInsProvider,
                  items: insuranceProviders
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            color: kBlack, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                  dropdownColor: kBackgroundColor,
                  onChanged: (String? value) {
                    setState(() {
                      newInsProvider = value!;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
              ),
              Text(
                'Current Coverage Type',
                style: TextStyle(
                  color: kWhite,
                  fontSize: size.FONT_SIZE * 15,
                ),
                textAlign: TextAlign.start,
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT),
              ),
              TextFormField(
                enabled: false,
                initialValue: initInsType,
                decoration: InputDecoration(
                  fillColor: kWhite.withOpacity(0.4),
                  filled: true,
                  prefixIcon: Icon(FontAwesomeIcons.stream, color: kIconColor),
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon:
                          Icon(FontAwesomeIcons.stream, color: kIconColor),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                        borderSide: BorderSide(
                          color: kGreen,
                        ),
                      ),
                      labelStyle: TextStyle(
                          color: kIconColor, fontWeight: FontWeight.bold),
                      labelText: "New Coverage Type"),
                  value: newInsType,
                  items: <String>[
                    '',
                    'Standard',
                    'Full',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            color: kBlack, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                  dropdownColor: kBackgroundColor,
                  onChanged: (String? value) {
                    setState(() {
                      newInsType = value!;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
              ),
              Text(
                'Current Insurance Start Date',
                style: TextStyle(
                  color: kWhite,
                  fontSize: size.FONT_SIZE * 15,
                ),
                textAlign: TextAlign.start,
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT),
              ),
              TextFormField(
                enabled: false,
                initialValue: initInsStartDate,
                decoration: InputDecoration(
                  fillColor: kWhite.withOpacity(0.4),
                  filled: true,
                  prefixIcon:
                      Icon(FontAwesomeIcons.calendarPlus, color: kIconColor),
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Form(
                key: insStartKey,
                autovalidateMode: AutovalidateMode.always,
                child: Padding(
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
                      setState(() => newInsStartDate = givenDate);
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
                      if (isBefore == true || newInsStartDate == '')
                        return null;
                      else
                        return ('Your Insurance policy cannot start in the future!');
                    },
                    inputType: InputType.date,
                    decoration: InputDecoration(
                        fillColor: kWhite.withOpacity(0.4),
                        filled: true,
                        prefixIcon: Icon(FontAwesomeIcons.calendarPlus,
                            color: kIconColor),
                        enabledBorder: UnderlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                          borderSide: BorderSide(
                            color: kGreen,
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: kRed, width: size.BLOCK_WIDTH * 1),
                        ),
                        labelStyle: TextStyle(
                            color: kIconColor, fontWeight: FontWeight.bold),
                        labelText: 'New Insurance Start Date'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
              ),
              Text(
                'Current Insurance End Date',
                style: TextStyle(
                  color: kWhite,
                  fontSize: size.FONT_SIZE * 15,
                ),
                textAlign: TextAlign.start,
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT),
              ),
              TextFormField(
                enabled: false,
                initialValue: initInsEndDate,
                decoration: InputDecoration(
                  fillColor: kWhite.withOpacity(0.4),
                  filled: true,
                  prefixIcon:
                      Icon(FontAwesomeIcons.calendarTimes, color: kIconColor),
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Form(
                key: insEndKey,
                autovalidateMode: AutovalidateMode.always,
                child: Padding(
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
                      setState(() => newInsEndDate = givenDate);
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
                      if (isAfter == false || newInsEndDate == '')
                        return null;
                      else
                        return ('Your Insurance policy is expired!');
                    },
                    inputType: InputType.date,
                    decoration: InputDecoration(
                        fillColor: kWhite.withOpacity(0.4),
                        filled: true,
                        prefixIcon: Icon(FontAwesomeIcons.calendarTimes,
                            color: kIconColor),
                        enabledBorder: UnderlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(size.BLOCK_HEIGHT * 1),
                          borderSide: BorderSide(
                            color: kGreen,
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: kRed, width: size.BLOCK_WIDTH * 1),
                        ),
                        labelStyle: TextStyle(
                            color: kIconColor, fontWeight: FontWeight.bold),
                        labelText: 'Insurance End Date'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 3),
                // ignore: deprecated_member_use
                child: FlatButton(
                  minWidth: size.BLOCK_WIDTH * 36,
                  height: size.BLOCK_HEIGHT * 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  color: Colors.green,
                  child: Text(
                    'Confirm Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.FONT_SIZE * 20,
                    ),
                  ),
                  onPressed: () async {
                    return showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(size.BLOCK_WIDTH * 7),
                          ),
                          title: Text(
                            "Update Vehicle Information",
                            style: TextStyle(
                              color: Color(0xffffffff),
                            ),
                          ),
                          content: Text(
                            "Are you sure you want to update your vehicle information?",
                            style: TextStyle(
                              color: Color(0xffffffff),
                              fontFamily: 'Glory',
                              fontWeight: FontWeight.bold,
                              fontSize: size.FONT_SIZE * 22,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Container(
                                height: size.BLOCK_HEIGHT * 7,
                                width: size.BLOCK_WIDTH * 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      size.BLOCK_WIDTH * 5),
                                  color: Color(0xff001233),
                                ),
                                child: Center(
                                  child: Text(
                                    "No",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xffffffff),
                                      fontFamily: 'Glory',
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.FONT_SIZE * 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: size.BLOCK_WIDTH * 2.5),
                              child: TextButton(
                                onPressed: () {
                                  // TODO: changeCarInfo();
                                },
                                child: Container(
                                  height: size.BLOCK_HEIGHT * 7,
                                  width: size.BLOCK_WIDTH * 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        size.BLOCK_WIDTH * 5),
                                    color: Color(0xffC80404),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Yes",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xffffffff),
                                        fontFamily: 'Glory',
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.FONT_SIZE * 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          backgroundColor: Color(0xff0353A4),
                        );
                      },
                      barrierDismissible: true,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
