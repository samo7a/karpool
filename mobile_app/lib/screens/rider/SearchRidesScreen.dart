import 'package:flutter/material.dart';
import 'package:mobile_app/models/RiderTrip.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/TripResultContainer.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchRidesScreen extends StatefulWidget {
  static const String id = 'searchRidesScreen';
  const SearchRidesScreen({Key? key}) : super(key: key);

  @override
  _SearchRidesScreenState createState() => _SearchRidesScreenState();
}

class _SearchRidesScreenState extends State<SearchRidesScreen> {
  String dateTime = "";
  String startLoc = 'Address 1';
  String destination = 'Address 2';
  String rideDate = '';

  TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  _selectRideDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2022, 12, 31)); // end of 2022
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String rideDate =
            "${picked.toLocal().month}/${picked.toLocal().day}/${picked.toLocal().year}"; //MM/DD/YYY
        _dateController.text = rideDate;
        print(rideDate);
      });
  }

  // static scheduled rides list
  List<RiderTrip> trips = [
    RiderTrip(
      timestamp: "8888",
      tripId: "1",
      date: "01/01/2021",
      time: "04:30 PM",
      fromAddress: "1111 S Semoran Blvd, 1111, winter park, fl, apt # 111 ",
      status: "Pending",
      toAddress: "very long address that I cannot wrap unless I add an expanded widget",
      estimatedPrice: 32.34,
      driverId: "23344",
      isOpen: true,
      polyLine: "polyLine",
      seatNumbers: 4,
      estimatedDistance: 111,
      estimatedDuration: 111,
      estimatedFare: 11,
      // driver: new User(
      //   uid: "939393",
      //   firstName: "Ahmed",
      //   lastName: "Elshetany",
      //   isDriver: true,
      //   isRider: true,
      //   isVerified: true,
      //   rating: 4,
      //   profileURL:
      //       "https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cGhvdG98ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",
      //   phoneNumber: "4074583995",
      // ),
    ),
    RiderTrip(
      tripId: "1",
      date: "01/01/2021",
      time: "04:30 PM",
      fromAddress: "1111 S Semoran Blvd, 1111, winter park, fl, apt # 111 ",
      status: "Pending",
      toAddress: "very long address that I cannot wrap unless I add an expanded widget",
      estimatedPrice: 32.34,
      driverId: "23344",
      isOpen: true,
      polyLine: "polyLine",
      seatNumbers: 4,
      estimatedDistance: 111,
      estimatedDuration: 111,
      estimatedFare: 11,
      timestamp: "8888",
      // driver: new User(
      //   uid: "939393",
      //   firstName: "Ahmed",
      //   lastName: "Elshetany",
      //   isDriver: true,
      //   isRider: true,
      //   isVerified: true,
      //   rating: 4,
      //   profileURL:
      //       "https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cGhvdG98ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",
      //   phoneNumber: "4074583995",
      // ),
    ),
    RiderTrip(
      timestamp: "8888",
      tripId: "1",
      date: "01/01/2021",
      time: "04:30 PM",
      fromAddress: "1111 S Semoran Blvd, 1111, winter park, fl, apt # 111 ",
      status: "Pending",
      toAddress: "very long address that I cannot wrap unless I add an expanded widget",
      estimatedPrice: 32.34,
      driverId: "23344",
      isOpen: true,
      polyLine: "polyLine",
      seatNumbers: 4,
      estimatedDistance: 111,
      estimatedDuration: 111,
      estimatedFare: 11,
      // driver: new User(
      //   uid: "939393",
      //   firstName: "Ahmed",
      //   lastName: "Elshetany",
      //   isDriver: true,
      //   isRider: true,
      //   isVerified: true,
      //   rating: 4,
      //   profileURL:
      //       "https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cGhvdG98ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",
      //   phoneNumber: "4074583995",
      // ),
    ),
    RiderTrip(
      timestamp: "8888",
      tripId: "1",
      date: "01/01/2021",
      time: "04:30 PM",
      fromAddress: "1111 S Semoran Blvd, 1111, winter park, fl, apt # 111 ",
      status: "Pending",
      toAddress: "very long address that I cannot wrap unless I add an expanded widget",
      estimatedPrice: 32.34,
      driverId: "23344",
      isOpen: true,
      polyLine: "polyLine",
      seatNumbers: 4,
      estimatedDistance: 111,
      estimatedDuration: 111,
      estimatedFare: 11,
      // driver: new User(
      //   uid: "939393",
      //   firstName: "Ahmed",
      //   lastName: "Elshetany",
      //   isDriver: true,
      //   isRider: true,
      //   isVerified: true,
      //   rating: 4,
      //   profileURL:
      //       "https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cGhvdG98ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",
      //   phoneNumber: "4074583995",
      // ),
    ),
  ];

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
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = Uuid().v4();
      });
    }
    getSuggestion(_controller.text);
  }

  _onToChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = Uuid().v4();
      });
    }
    getEndSuggestion(_endController.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyDPY8DgggKHLJBU_G2TGI5KYcr_kYVq4jo";
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
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
    String kPLACES_API_KEY = "AIzaSyDPY8DgggKHLJBU_G2TGI5KYcr_kYVq4jo";
    String type = '(regions)';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
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

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return Scaffold(
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: kWhite,
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 0, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Date of Ride",
                style: TextStyle(
                  fontFamily: 'Glory',
                  fontWeight: FontWeight.bold,
                  fontSize: size.FONT_SIZE * 20,
                  color: kWhite,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: size.BLOCK_HEIGHT,
              ),
              InkWell(
                onTap: () {
                  _selectRideDate(context);
                },
                child: Container(
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Ex: 01/01/2021",
                        hintStyle: TextStyle(fontSize: size.FONT_SIZE * 19),
                        contentPadding: EdgeInsets.all(8),
                      ),
                      validator: MultiValidator(
                        [
                          RequiredValidator(
                            errorText: "Ride Date Required",
                          ),
                        ],
                      ),
                      onChanged: (value) => setState(() => rideDate = value),
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  height: size.BLOCK_HEIGHT * 6,
                  width: size.BLOCK_WIDTH * 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: kWhite,
                  ),
                ),
              ),
              SizedBox(height: size.BLOCK_HEIGHT * 3),
              Text(
                "Start Location",
                style: TextStyle(
                  fontFamily: 'Glory',
                  fontWeight: FontWeight.bold,
                  fontSize: size.FONT_SIZE * 20,
                  color: kWhite,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: size.BLOCK_HEIGHT,
              ),
              Container(
                child: TextFormField(
                  controller: _controller,
                  onChanged: (value) => setState(() => startLoc = value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Ex: 123 Sesame Street",
                    hintStyle: TextStyle(fontSize: size.FONT_SIZE * 19),
                    contentPadding: EdgeInsets.all(8),
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                height: size.BLOCK_HEIGHT * 6,
                width: size.BLOCK_WIDTH * 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: kWhite,
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
                          fontSize: size.FONT_SIZE * 20,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          startLoc = _placeList[index]["description"];
                          _controller.text = _placeList[index]["description"];
                          _placeList = [];
                        });
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                height: size.BLOCK_HEIGHT * 3,
              ),
              Text(
                "Destination",
                style: TextStyle(
                  fontFamily: 'Glory',
                  fontWeight: FontWeight.bold,
                  fontSize: size.FONT_SIZE * 20,
                  color: kWhite,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: size.BLOCK_HEIGHT,
              ),
              Container(
                child: TextFormField(
                  controller: _endController,
                  onChanged: (value) => setState(() => destination = value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Ex: 456 Sesame Street",
                    hintStyle: TextStyle(fontSize: size.FONT_SIZE * 19),
                    contentPadding: EdgeInsets.all(8),
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                height: size.BLOCK_HEIGHT * 6,
                width: size.BLOCK_WIDTH * 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: kWhite,
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
                          fontSize: size.FONT_SIZE * 20,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          destination = _toPlaceList[index]["description"];
                          _endController.text = _toPlaceList[index]["description"];
                          _toPlaceList = [];
                        });
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                height: size.BLOCK_HEIGHT * 3,
              ),
              // ignore: deprecated_member_use
              FlatButton(
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
                onPressed: () {
                  // TODO: Link search to backend & retrieve trips map/data
                },
              ),
              SizedBox(
                height: size.BLOCK_HEIGHT * 5,
              ),
              Text(
                "Search Results:",
                style: TextStyle(
                  color: kWhite,
                  fontSize: size.FONT_SIZE * 28,
                ),
              ),
              ListView.builder(
                itemCount: trips.length,
                physics: NeverScrollableScrollPhysics(),
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
                                      // TODO: Add ride to trip list
                                      // TODO: Register Scheduling in backend
                                      print("Chose Yes");
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text(
                                      "YES",
                                      style: TextStyle(
                                        fontFamily: 'Glory',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20, // size object not working here,
                                      ),
                                    ),
                                  ),
                                  // ignore: deprecated_member_use
                                  FlatButton(
                                    onPressed: () {
                                      print("Chose No");
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text(
                                      "NO",
                                      style: TextStyle(
                                        fontFamily: 'Glory',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20, // size object not working here,
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
                          trip: trips[index],
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
    );
  }
}
