import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobile_app/util/Size.dart';

class ScheduleScreen extends StatefulWidget {
  static const String id = 'scheduleScreen';

  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String get cancelButtonName => "Add a Ride";
  String get addButtonName => "Cancel";
  String date = '';
  String time = '';
  String seats = '';
  String startLocation = '';
  String endLocation = '';

  @override
  Widget build(BuildContext context) {
    Size size = new Size(Context: context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          title: Text("Schedule a Ride"),
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
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Date',
                  style: TextStyle(
                      color: Color(0xFF33415C), fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: FormBuilderDateTimePicker(
                  name: 'date',
                  onChanged: (value) => setState(() => date = value.toString()),
                  inputType: InputType.date,
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon:
                          Icon(FontAwesomeIcons.calendarDay, color: kIconColor),
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
                      hintText: "Date"),
                  initialTime: TimeOfDay(hour: 8, minute: 0),
                  initialValue: DateTime.now(),
                  enabled: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Text(
                  'Time',
                  style: TextStyle(
                      color: Color(0xFF33415C), fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: FormBuilderDateTimePicker(
                  name: 'time',
                  onChanged: (value) => setState(() => time = value.toString()),
                  inputType: InputType.time,
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon:
                          Icon(FontAwesomeIcons.calendarDay, color: kIconColor),
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
                      hintText: "Time"),
                  initialTime: TimeOfDay(hour: 8, minute: 0),
                  initialValue: DateTime.now(),
                  enabled: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Text(
                  'Number of Seats',
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
                        prefixIcon:
                            Icon(FontAwesomeIcons.chair, color: kIconColor),
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
                        hintText: "Number of Seats"),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Number of Seats Required!"),
                      MinLengthValidator(1, errorText: "Minimum of 1 Seat"),
                      MaxLengthValidator(5, errorText: "Maximum of 5 Seats")
                    ]),
                    onChanged: (value) => setState(() => seats = value),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Text(
                  'Starting Location',
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
                        prefixIcon: Icon(FontAwesomeIcons.mapMarkedAlt,
                            color: Colors.green),
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
                        hintText: "Address for Starting Location"),
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: "Starting Location is Required!"),
                    ]),
                    onChanged: (value) => setState(() => startLocation = value),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Text(
                  'Ending Location',
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
                        prefixIcon: Icon(FontAwesomeIcons.mapMarkedAlt,
                            color: Colors.red),
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
                        hintText: "Address for Ending Location"),
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: "Ending Location is Required!"),
                    ]),
                    onChanged: (value) => setState(() => endLocation = value),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 75.0),
                child: Container(
                  height: size.BLOCK_HEIGHT * 7,
                  width: size.BLOCK_WIDTH * 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 16),
                    color: Colors.green,
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      cancelButtonName,
                      style: TextStyle(
                          fontSize: size.FONT_SIZE * 20,
                          color: Colors.white,
                          height: 1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Container(
                  height: size.BLOCK_HEIGHT * 7,
                  width: size.BLOCK_WIDTH * 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 16),
                    color: Colors.red,
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      addButtonName,
                      style: TextStyle(
                          fontSize: size.FONT_SIZE * 20,
                          color: Colors.white,
                          height: 1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
