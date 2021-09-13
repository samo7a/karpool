import 'package:flutter/material.dart';
import 'package:mobile_app/screens/rider/SearchRidesScreen.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/widgets/ConfiramtionAlert.dart';
import 'package:mobile_app/widgets/TripContainer.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({Key? key}) : super(key: key);

  @override
  _RiderHomeScreenState createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  final String tripDate = '01/01/2021';
  final String tripTime = '04:30 PM';
  final String from = 'Address 1';
  final String to = 'Address 2';

  // static scheduled trips list
  List<Map<String, String>> trips = [
    {
      "tripID": "1",
      "tripDate": "01/01/2021",
      "tripTime": "04:30 PM",
      "from": "Address 1",
      "to": "Address 2",
    },
    {
      "tripID": "2",
      "tripDate": "01/10/2021",
      "tripTime": "04:30 PM",
      "from": "Address 1",
      "to": "Address 2",
    },
    {
      "tripID": "3",
      "tripDate": "01/20/2021",
      "tripTime": "04:30 PM",
      "from": "Address 1",
      "to": "Address 2",
    },
    {
      "tripID": "4",
      "tripDate": "01/30/2021",
      "tripTime": "04:30 PM",
      "from": "Address 1",
      "to": "Address 2",
    },
  ];

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return Scaffold(
      body: Container(
        color: kDashboardColor,
        child: ListView.builder(
            itemCount: trips.length,
            itemBuilder: (BuildContext context, int index) {
              final trip = trips[index];
              return Dismissible(
                direction: DismissDirection.endToStart,
                key: Key(trip["tripID"] ?? ""),
                onDismissed: (direction) {
                  trips.removeAt(index);
                },
                confirmDismiss: (direction) async {
                    return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm Ride Cancellation"),
                        content: Text(
                          "Are you sure you wish to cancel your ride?",
                          style: TextStyle(
                            fontFamily: 'Glory', 
                            fontWeight: FontWeight.bold, 
                            fontSize: size.FONT_SIZE * 22,
                          ),
                        ),
                        actions: <Widget>[
                          // ignore: deprecated_member_use
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text(
                              "YES", 
                              style: TextStyle(
                                fontFamily: 'Glory', 
                                fontWeight: FontWeight.bold, 
                                fontSize: 20, // size object not working here
                              ),
                            ),
                          ),
                          // ignore: deprecated_member_use
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text(
                              "NO",
                              style: TextStyle(
                                fontFamily: 'Glory', 
                                fontWeight: FontWeight.bold, 
                                fontSize: 20 // size object not working here
                              ),
                            ),
                          ),
                        ],
                        backgroundColor: kWhite,
                      );
                    },
                  );
                },
                background: Container(
                  child: Center(
                    child: Text(
                      'Delete Ride', 
                      style: TextStyle(
                        color: kWhite,
                        fontFamily: 'Glory',
                        fontWeight: FontWeight.bold,
                        fontSize: size.FONT_SIZE * 26,
                      ),
                    ),
                  ),
                  color: kRed,
                ),
                child: Container(
                  child: Center(
                    child: TripContainer(
                      date: trips[index]['tripDate'] ?? "",
                      time: trips[index]['tripTime'] ?? "",
                      fromAddress: trips[index]['from'] ?? "",
                      toAddress: trips[index]['to'] ?? "",
                    ),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, SearchRidesScreen.id);
        },
        child: Icon(
          Icons.search,
        ),
        backgroundColor: kButtonColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


/* ConfirmationAlert(
                        backgroundColor: kDrawerColor,
                        leftButtonText: "Yes",
                        rightButtonText: "Cancel",
                        leftButtonColor: kGreen,
                        rightButtonColor: kRed,
                        textColor: kWhite,
                        title: "Trip Deletion",
                        msg: "Are you sure you want cancel this trip?",
                        leftButtonAction: () {
                          // TODO: call function for api call to delete trip if yes.
                          Navigator.of(context).pop(true);
                          trips.removeAt(index);
                          Scaffold.of(context)
                              // ignore: deprecated_member_use
                              .showSnackBar(
                                  SnackBar(content: Text("Trip Deleted")));
                        },
                        rightButtonAction: () {
                          Navigator.of(context).pop(false);
                        },
                      );*/