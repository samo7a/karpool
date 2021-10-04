import 'dart:convert';
import 'dart:ui';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/models/User.dart';
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

  String get cancelButtonName => "Cancel";
  String get addButtonName => "Add a Ride";

  DateTime date = DateTime.now();

  late String time = getTime(DateTime.now());
  double seats = 1;
  String startAddress = '';
  String endAddress = '';
  String startPlaceId = '';
  String endPlaceId = '';

//search ride code start
  final _controller = TextEditingController();
  final _endController = TextEditingController();
  String _sessionToken = '';
  List<dynamic> _placeList = [];
  List<dynamic> _toPlaceList = [];

  @override
  void initState() {
    super.initState();
    print("print date: " + date.toString());
    print("print time: " + time.toString());
    _controller.addListener(() {
      _onChanged();
    });
    _endController.addListener(() {
      _onToChanged();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _endController.dispose();
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

  String getTime(DateTime dt) {
    String iso = dt.toIso8601String();
    String time = iso.split("T")[1];
    return time;
  }

  void getSuggestion(String input) async {
    // ignore: non_constant_identifier_names
    String kPLACES_API_KEY = dotenv.get("GOOGLE_API_KEY");
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
    } else {
      print("error in getSuggestions");
      throw Exception('Failed to load predictions');
    }
  }

  void getEndSuggestion(String input) async {
    String kPLACESAPIKEY = dotenv.get("GOOGLE_API_KEY");
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$kPLACESAPIKEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          _toPlaceList = json.decode(response.body)['predictions'];
        });
    } else {
      print("error in getSuggestions");
      throw Exception('Failed to load predictions');
    }
  }

  void addRide() async {
    EasyLoading.show(status: "Adding Ride");
    HttpsCallable addRide = FirebaseFunctions.instance.httpsCallable("trip-createAddedTrip");
    print("addRide: date: " + date.toString());
    var array = date.toIso8601String().split("T");
    String d = array[0] + "T" + time + "Z";
    print(d);
    Map<String, dynamic> obj = {
      "startTime": d,
      "startAddress": startAddress,
      "endAddress": endAddress,
      "startPlaceID": startPlaceId,
      "endPlaceID": endPlaceId,
      "seatsAvailable": seats,
    };
    print(obj);
    try {
      await addRide(obj);
      EasyLoading.dismiss();
      Navigator.pop(context);
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network Error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = new Size(Context: context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kDashboardColor,
        appBar: AppBar(
          backgroundColor: kDashboardColor,
          title: Text(
            "Schedule a Ride",
          ),
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
            horizontal: size.BLOCK_WIDTH * 10,
          ),
          child: Center(
            child: _getScheduleWidget(size, context),
          ),
        ),
      ),
    );
  }

  _getScheduleWidget(Size size, BuildContext context) {
    final uid = ModalRoute.of(context)!.settings.arguments as String?;
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction, // Auto Validation Check
      key: scheduleKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
            child: Text(
              'Date',
              style: TextStyle(
                fontFamily: 'Glory',
                color: kWhite,
                fontSize: size.FONT_SIZE * 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
            child: FormBuilderDateTimePicker(
              name: 'date',
              onChanged: (value) {
                setState(() {
                  date = value!;
                });
                print(date);
              },
              inputType: InputType.date,
              decoration: InputDecoration(
                fillColor: kWhite.withOpacity(0.4),
                filled: true,
                prefixIcon: Icon(FontAwesomeIcons.calendarDay, color: kIconColor),
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
                hintText: "Date",
              ),
              style: TextStyle(fontWeight: FontWeight.bold),
              initialTime: TimeOfDay(hour: 0, minute: 0),
              initialValue: DateTime.now(),
              firstDate: DateTime.now(),
              enabled: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
            child: Text(
              'Time',
              style: TextStyle(
                fontFamily: 'Glory',
                fontWeight: FontWeight.bold,
                fontSize: size.FONT_SIZE * 20,
                color: kWhite,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
            child: FormBuilderDateTimePicker(
              name: 'time',
              onChanged: (value) {
                String t = getTime(value!);
                print(value);
                setState(() => time = t);
                print(time);
              },
              inputType: InputType.time,
              decoration: InputDecoration(
                  fillColor: kWhite.withOpacity(0.4),
                  filled: true,
                  prefixIcon: Icon(FontAwesomeIcons.calendarDay, color: kIconColor),
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
            padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
            child: Text(
              'Number of Seats Available',
              style: TextStyle(
                fontFamily: 'Glory',
                fontWeight: FontWeight.bold,
                fontSize: size.FONT_SIZE * 20,
                color: kWhite,
              ),
            ),
          ),
          Slider(
            activeColor: Color(0xff0466C8),
            inactiveColor: Color(0xff979DAC),
            value: seats,
            min: 1,
            max: 5,
            divisions: 4,
            label: seats.round().toString(),
            onChanged: (double value) {
              setState(() {
                seats = value;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
            child: Text(
              'Start Location',
              style: TextStyle(
                fontFamily: 'Glory',
                fontWeight: FontWeight.bold,
                fontSize: size.FONT_SIZE * 20,
                color: kWhite,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
            child: TextFormField(
              onChanged: (value) => setState(() => startAddress = value),
              controller: _controller,
              decoration: InputDecoration(
                fillColor: kWhite.withOpacity(0.4),
                filled: true,
                prefixIcon: Icon(FontAwesomeIcons.mapPin, color: kIconColor),
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
                hintText: "Address for Starting Location",
              ),
              validator: MultiValidator([
                RequiredValidator(errorText: "Starting Location is Required!"),
              ]),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
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
                    _controller.addListener(_onChanged);
                    setState(() {
                      startAddress = _placeList[index]["description"];
                      startPlaceId = _placeList[index]["place_id"] ?? " ";
                      _controller.text = _placeList[index]["description"];
                      _placeList.clear();
                    });
                    _controller.removeListener(() {});
                  },
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
            child: Text(
              'Ending Location',
              style: TextStyle(
                fontFamily: 'Glory',
                fontWeight: FontWeight.bold,
                fontSize: size.FONT_SIZE * 20,
                color: kWhite,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
            child: TextFormField(
              controller: _endController,
              onChanged: (value) => setState(() => endAddress = value),
              decoration: InputDecoration(
                fillColor: kWhite.withOpacity(0.4),
                filled: true,
                prefixIcon: Icon(FontAwesomeIcons.mapPin, color: kIconColor),
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
                hintText: "Address for Ending Location",
              ),
              validator: MultiValidator(
                [
                  RequiredValidator(errorText: "Ending Location is Required!"),
                ],
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
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
                    _endController.addListener(_onToChanged);
                    setState(() {
                      endAddress = _toPlaceList[index]["description"];
                      endPlaceId = _toPlaceList[index]["place_id"];
                      _endController.text = _toPlaceList[index]["description"];
                      _toPlaceList.clear();
                    });
                    _endController.removeListener(() {});
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
                onPressed: () => addRide(),
                child: Text(
                  addButtonName,
                  style: TextStyle(fontSize: size.FONT_SIZE * 20, color: Colors.white, height: 1),
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
                onPressed: () => Navigator.pop(context, null),
                child: Text(
                  cancelButtonName,
                  style: TextStyle(
                    fontSize: size.FONT_SIZE * 20,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
