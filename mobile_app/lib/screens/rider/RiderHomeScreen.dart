import 'package:flutter/material.dart';
import 'package:mobile_app/models/RiderTrip.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/screens/rider/SearchRidesScreen.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/Size.dart';
// import 'package:mobile_app/widgets/ConfiramtionAlert.dart';
import 'package:mobile_app/widgets/RideContainer.dart';

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

  // static scheduled rides list
  // TODO: API call to get scheduled rides map/...
  List<RiderTrip> trips = [
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
      driver: new User(
        uid: "939393",
        firstName: "Ahmed",
        lastName: "Elshetany",
        isDriver: true,
        isRider: true,
        isVerified: true,
        rating: 4,
        profileURL:
            "https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cGhvdG98ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",
        phoneNumber: "4074583995",
      ),
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
      driver: new User(
        uid: "939393",
        firstName: "Ahmed",
        lastName: "Elshetany",
        isDriver: true,
        isRider: true,
        isVerified: true,
        rating: 4,
        profileURL:
            "https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cGhvdG98ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",
        phoneNumber: "4074583995",
      ),
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
      driver: new User(
        uid: "939393",
        firstName: "Ahmed",
        lastName: "Elshetany",
        isDriver: true,
        isRider: true,
        isVerified: true,
        rating: 4,
        profileURL:
            "https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cGhvdG98ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",
        phoneNumber: "4074583995",
      ),
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
      driver: new User(
        uid: "939393",
        firstName: "Ahmed",
        lastName: "Elshetany",
        isDriver: true,
        isRider: true,
        isVerified: true,
        rating: 4,
        profileURL:
            "https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cGhvdG98ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",
        phoneNumber: "4074583995",
      ),
    ),
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
                key: Key(trip.tripId),
                onDismissed: (direction) {
                  // TODO: API call to delete scheduled ride
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Delete Ride',
                        style: TextStyle(
                          color: kWhite,
                          fontFamily: 'Glory',
                          fontWeight: FontWeight.bold,
                          fontSize: size.FONT_SIZE * 26,
                        ),
                      ),
                      SizedBox(
                        width: size.BLOCK_WIDTH * 2,
                      ),
                      Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.white,
                        size: size.FONT_SIZE * 30,
                      ),
                    ],
                  ),
                  color: kRed,
                ),
                child: Container(
                  child: Center(
                    child: RideContainer(
                      trip: trip,
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
