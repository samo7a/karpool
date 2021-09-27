import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/util/Size.dart';

class ScheduleScreen extends StatefulWidget {
  static const String id = 'scheduleScreen';

  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  GlobalKey<FormState> scheduleKey = GlobalKey<FormState>();

  String get cancelButtonName => "Add a Ride";
  String get addButtonName => "Cancel";
  String date = '';
  String time = '';
  String seats = '';
  String startAddress = '';
  String endAddress = '';
  //String startLocation = '';
  //String endLocation = '';

//search ride code start
  final _controller = TextEditingController();
  final _endController = TextEditingController();
  String _sessionToken = '';
  List<dynamic> _placeList = [];
  List<dynamic> _toPlaceList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
    _endController.addListener(() {
      _onToChanged();
    });
  }

  _onChanged() {
    setState(() {
      _sessionToken = Uuid().v4();
    });
    getSuggestion(_controller.text);
  }

  _onToChanged() {
    setState(() {
      _sessionToken = Uuid().v4();
    });

    getEndSuggestion(_endController.text);
  }

  void getSuggestion(String input) async {
    // ignore: non_constant_identifier_names
    String kPLACES_API_KEY = "AIzaSyDPY8DgggKHLJBU_G2TGI5KYcr_kYVq4jo";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      print("error in getSuggestions");
      throw Exception('Failed to load predictions');
    }
  }

  void getEndSuggestion(String input) async {
    String kPLACESAPIKEY = "AIzaSyDPY8DgggKHLJBU_G2TGI5KYcr_kYVq4jo";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACESAPIKEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    print("here: ----> " + response.toString());
    if (response.statusCode == 200) {
      setState(() {
        _toPlaceList = json.decode(response.body)['predictions'];
      });
    } else {
      print("error in getSuggestions");
      throw Exception('Failed to load predictions');
    }
  }
// search ride code end

  @override
  Widget build(BuildContext context) {
    Size size = new Size(Context: context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kDashboardColor,
        appBar: AppBar(
          backgroundColor: kDashboardColor,
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
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            children: [
              Center(child: _getScheduleWidget(size, context)),
            ],
          ),
        ),
      ),
    );
  }

  _getScheduleWidget(Size size, BuildContext context) {
    return Center(
      child: Form(
        autovalidateMode: AutovalidateMode.always, // Auto Validation Check
        key: scheduleKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'Date',
                style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
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
                    hintStyle: TextStyle(color: kIconColor),
                    hintText: "Date"),
                style: TextStyle(fontWeight: FontWeight.bold),
                initialTime: TimeOfDay(hour: 8, minute: 0),
                initialValue: DateTime.now(),
                enabled: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Text(
                'Time',
                style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
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
                    hintStyle: TextStyle(color: kIconColor),
                    hintText: "Time"),
                style: TextStyle(fontWeight: FontWeight.bold),
                initialTime: TimeOfDay(hour: 8, minute: 0),
                initialValue: DateTime.now(),
                enabled: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Text(
                'Number of Seats Available',
                style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
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
                      hintStyle: TextStyle(color: kIconColor),
                      hintText: "Number of Seats Available"),
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
                'Starting Address',
                style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: TextFormField(
                  onChanged: (value) => setState(() => startAddress = value),
                  controller: _controller,
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      prefixIcon:
                          Icon(FontAwesomeIcons.mapPin, color: kIconColor),
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
                      hintStyle: TextStyle(color: kIconColor),
                      hintText: "Address for Starting Location"),
                  validator: MultiValidator([
                    RequiredValidator(
                        errorText: "Starting Location is Required!"),
                  ]),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kWhite,
                  ),
                  child: ListTile(
                    title: Text(
                      _placeList[index]["description"],
                      style: TextStyle(
                        fontFamily: 'Glory',
                        fontWeight: FontWeight.bold,
                        fontSize: size.FONT_SIZE * 15,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        startAddress = _placeList[index]["description"];
                        _controller.text = _placeList[index]["description"];
                        _placeList = [];
                      });
                    },
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Text(
                'Ending Address',
                style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: TextFormField(
                  onChanged: (value) => setState(() => endAddress = value),
                  controller: _endController,
                  decoration: InputDecoration(
                      fillColor: kWhite.withOpacity(0.4),
                      filled: true,
                      suffixIcon:
                          Icon(FontAwesomeIcons.mapPin, color: kIconColor),
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
                      hintStyle: TextStyle(color: kIconColor),
                      hintText: "Address for Ending Location"),
                  validator: MultiValidator([
                    RequiredValidator(
                        errorText: "Ending Location is Required!"),
                  ]),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _toPlaceList.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kWhite,
                  ),
                  child: ListTile(
                    title: Text(
                      _toPlaceList[index]["description"],
                      style: TextStyle(
                        fontFamily: 'Glory',
                        fontWeight: FontWeight.bold,
                        fontSize: size.FONT_SIZE * 15,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        endAddress = _toPlaceList[index]["description"];
                        _endController.text =
                            _toPlaceList[index]["description"];
                        _toPlaceList = [];
                      });
                    },
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0),
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
    );
  }
}
