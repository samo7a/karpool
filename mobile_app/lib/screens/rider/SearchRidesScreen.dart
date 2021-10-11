import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/models/RiderTrip.dart';
import 'package:mobile_app/util/Auth.dart';
// import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/TripResultContainer.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SearchRidesScreen extends StatefulWidget {
  static const String id = 'searchRidesScreen';
  const SearchRidesScreen({Key? key}) : super(key: key);

  @override
  _SearchRidesScreenState createState() => _SearchRidesScreenState();
}

class _SearchRidesScreenState extends State<SearchRidesScreen> {
  GlobalKey<FormState> searchKey = GlobalKey<FormState>();
  // late final auth = Provider.of<Auth>(context, listen: false);
  // String dateTime = "";
  String startLoc = 'Address 1';
  String destination = 'Address 2';
  String rideDate = '';
  String startPlaceId = '';
  String endPlaceId = '';
  double seats = 1;

  DateTime selectedDate = DateTime.now();
  DateTime date = DateTime.now();

  // static scheduled rides list
  List<RiderTrip> searchResults = [];

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

  void search() async {
    EasyLoading.show(status: "Searching...");
    setState(() {
      searchResults = [];
    });
    Map<String, String> obj = {
      "startPlaceID": startPlaceId,
      "endPlaceID": endPlaceId,
    };

    print("start : " + startPlaceId);
    print("end : $endPlaceId");
    print("date: " + date.toUtc().toIso8601String());
    HttpsCallable getCoordinates =
        FirebaseFunctions.instance.httpsCallable("trip-getStartEndCoordinates");

    HttpsCallable search = FirebaseFunctions.instance.httpsCallable("trip-searchTrips");
    try {
      final points = await getCoordinates(obj);

      Map<String, dynamic> obj2 = {
        "pickupLocation": {
          "x": points.data["startLocation"]["longitude"],
          "y": points.data["startLocation"]["latitude"],
        },
        "dropoffLocation": {
          "x": points.data["endLocation"]["longitude"],
          "y": points.data["endLocation"]["latitude"],
        },
        "passengerCount": seats,
        "startDate": date.toUtc().toIso8601String(),
      };
      print(obj2.toString());
      List<RiderTrip> futureTrips = [];
      final result = await search(obj2);
      final data = result.data["trips"];
      int length = data.length;

      print("search Results");
      print(data);
      print(length);
      if (length == 0) {
        print("no results");
        setState(() {
          searchResults = futureTrips;
        });
      } else {
        for (int i = 0; i < length; i++) {
          String tripId = data[i]["docID"];
          String driverId = data[i]["driverID"];
          dynamic timestamp = data[i]["startTime"];
          DateTime ts =
              Timestamp(timestamp["_seconds"], timestamp["_nanoseconds"]).toDate().toUtc();
          String date = ts.month.toString() + "-" + ts.day.toString() + "-" + ts.year.toString();
          String time = DateFormat('hh:mm a').format(ts);
          String startAddress = data[i]["startAddress"] ?? " ";
          String endAddress = data[i]["endAddress"] ?? " ";
          int seatCount = data[i]["seatsAvailable"];
          Map<String, double> startPoint = {
            "latitude": data[i]["startLocation"]["_latitude"],
            "longitude": data[i]["startLocation"]["_longitude"],
          };
          Map<String, double> endPoint = {
            "latitude": data[i]["endLocation"]["_latitude"],
            "longitude": data[i]["endLocation"]["_longitude"],
          };

          double estimatedPrice =
              double.parse((result.data["estimatedFare"] ?? 0.0).toStringAsFixed(2));
          String polyLine = data[i]["polyline"];
          bool isOpen = data[i]["isOpen"];
          double estimatedDistance =
              double.parse((data[i]["estimatedDistance"] / 1609).toStringAsFixed(2));
          double estimatedDuration = data[i]["estimatedDistance"] / 60;

          futureTrips.add(
            RiderTrip(
              timestamp: ts,
              tripId: tripId,
              date: date,
              time: time,
              fromAddress: startAddress,
              status: "status",
              toAddress: endAddress,
              driverId: driverId,
              isOpen: isOpen,
              polyLine: polyLine,
              seatNumbers: seatCount,
              estimatedDistance: estimatedDistance,
              estimatedDuration: estimatedDuration,
              estimatedFare: estimatedPrice,
              startPoint: startPoint,
              endPoint: endPoint,
            ),
          );
        }
      }
      setState(() {
        searchResults = futureTrips;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("No Results!");
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kDashboardColor,
        appBar: AppBar(
          backgroundColor: kDashboardColor,
          title: Text(
            'Search for a ride',
            style: TextStyle(
              fontSize: size.FONT_SIZE * 22,
              color: kWhite,
            ),
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
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: size.BLOCK_HEIGHT * 2,
              horizontal: size.BLOCK_WIDTH * 10,
            ),
            child: Center(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: searchKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
                      child: Text(
                        "Date of Ride",
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
                        "Start Location",
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
                        onChanged: (value) => setState(() => startLoc = value),
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
                                startLoc = _placeList[index]["description"];
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
                        "Ending Location",
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
                        onChanged: (value) => setState(() => destination = value),
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
                                destination = _toPlaceList[index]["description"];
                                _endController.text = _toPlaceList[index]["description"];
                                endPlaceId = _toPlaceList[index]["place_id"] ?? " ";
                                _toPlaceList.clear();
                              });
                              _endController.removeListener(() {});
                            },
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size.BLOCK_HEIGHT * 2),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        minWidth: size.BLOCK_WIDTH * 40,
                        height: size.BLOCK_HEIGHT * 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        color: Colors.green,
                        child: Text(
                          'Search Rides',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.FONT_SIZE * 22,
                          ),
                        ),
                        onPressed: search,
                      ),
                    ),
                    SizedBox(
                      height: size.BLOCK_HEIGHT * 5,
                    ),
                    searchResults.length != 0
                        ? Text(
                            "Search Results:",
                            style: TextStyle(
                              color: kWhite,
                              fontSize: size.FONT_SIZE * 28,
                            ),
                          )
                        : Container(),
                    ListView.builder(
                      itemCount: searchResults.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm Ride Scheduling"),
                                      content: Text(
                                        "Are you sure you wish to schedule this ride?",
                                        style: TextStyle(
                                          fontFamily: 'Glory',
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.FONT_SIZE * 22,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                          onPressed: () {
                                            print("Chose Yes");
                                            Navigator.of(context).pop(true);
                                          },
                                          child: Text(
                                            "YES",
                                            style: TextStyle(
                                              fontFamily: 'Glory',
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.FONT_SIZE * 22,
                                            ),
                                          ),
                                        ),
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                          onPressed: () {
                                            print("Chose No");
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Text(
                                            "NO",
                                            style: TextStyle(
                                              fontFamily: 'Glory',
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.FONT_SIZE * 22,
                                            ),
                                          ),
                                        ),
                                      ],
                                      backgroundColor: kWhite,
                                    );
                                  },
                                );
                              },
                              child: TripResultContainer(
                                trip: searchResults[index],
                                placeIds: {
                                  "startPlaceID": startPlaceId,
                                  "endPlaceID": endPlaceId,
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
