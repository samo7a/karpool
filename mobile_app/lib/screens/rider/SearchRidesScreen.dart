import 'package:flutter/material.dart';
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
  List<Map<String, String>> trips = [
    {
      "tripID": "1",
      "tripDate": "01/01/2021",
      "tripTime": "04:30 PM",
      "from": "1111 S Semoran Blvd, 1111, winter park, fl, apt # 111 ",
      "to": "very long address that I cannot wrap unless I add an expanded widget",
      "price": "32",
      "imageLink": "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
    },
    {
      "tripID": "2",
      "tripDate": "01/10/2021",
      "tripTime": "04:30 PM",
      "from": "Address 1",
      "to": "Address 2",
      "price": "45",
      "imageLink": "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
    },
    {
      "tripID": "3",
      "tripDate": "01/20/2021",
      "tripTime": "04:30 PM",
      "from": "Address 1",
      "to": "Address 2",
      "price": "12",
      "imageLink": "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
    },
    {
      "tripID": "4",
      "tripDate": "01/30/2021",
      "tripTime": "04:30 PM",
      "from": "Address 1",
      "to": "Address 2",
      "price": "17",
      "imageLink": "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
    },
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
    String type = '(regions)';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    print("here: ----> " + response.toString());
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
                  // TODO: Add address api --> maps/google for input
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
                  return ListTile(
                    title: Text(_placeList[index]["description"]),
                    onTap: () {
                      setState(() {
                        startLoc = _placeList[index]["description"];
                        _controller.text = _placeList[index]["description"];
                        _placeList = [];
                        print("RESULT: " + startLoc);
                      });
                    },
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
                  // TODO: Add address api --> maps/google for input
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
                  return ListTile(
                    title: Text(_toPlaceList[index]["description"]),
                    onTap: () {
                      setState(() {
                        destination = _toPlaceList[index]["description"];
                        _endController.text = _toPlaceList[index]["description"];
                        _toPlaceList = [];
                        print("RESULT: " + destination);
                      });
                    },
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
                          date: trips[index]['tripDate'] ?? "",
                          time: trips[index]['tripTime'] ?? "",
                          fromAddress: trips[index]['from'] ?? "",
                          toAddress: trips[index]['to'] ?? "",
                          estimatedPrice: trips[index]['price'] ?? "",
                          profilePic: trips[index]['imageLink'] ?? "",
                          status: "Pending",
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
