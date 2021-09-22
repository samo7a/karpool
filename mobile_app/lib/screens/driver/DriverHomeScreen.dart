import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_app/models/DriverTrip.dart';
import 'package:mobile_app/models/RiderTrip.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/RideContainer.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ScheduleScreen.dart';

class DriverHomeScreen extends StatefulWidget {
  final User user;
  const DriverHomeScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  User? user;

  void initState() {
    super.initState();
    user = widget.user;
    tripFromFireBase();
  }

  final String tripDate = '01/01/2021';
  final String tripTime = '04:30 PM';
  final String from = 'Address 1';
  final String to = 'Address 2';
  List<DriverTrip> trips2 = [];

  Future<void> tripFromFireBase() async {
    // User driver = await User.getDriverFromFireBase(th);
    EasyLoading.show(status: "Loading...");
    String uid = user!.uid;
    print("driverID: " + uid);
    final obj = <String, dynamic>{
      "driverID": uid,
    };
    HttpsCallable getTrips = FirebaseFunctions.instance.httpsCallable.call('trip-getDriverTrips');
    // List<RiderTrip> tripList = [];

    setState(() {
      trips.clear();
    });
    final result;
    final data;
    int length;
    try {
      result = await getTrips(obj);
      data = result.data;
      length = result.data.length;
      if (length == 0) {
        EasyLoading.dismiss();
        setState(() {
          trips.clear();
        });
        print("cancel");
        return;
      }
      print("length: " + length.toString());
      // print(data);
      for (int i = 0; i < length; i++) {
        String tripId = data[i]["docID"];
        String driverId = data[i]["driverID"];
        print("driverId from result: " + data[i]["driverID"]);
        User driver = await User.getDriverFromFireBase(driverId);
        // print(driver.firstName);
        dynamic timestamp = data[i]["startTime"] ?? "error";
        print("timestamp $timestamp");
        DateTime ts = Timestamp(timestamp["_seconds"], timestamp["_nanoseconds"]).toDate();
        //print(DateTime.parse(timestamp.toDate().toString()));
        print("date $ts");
        String date = ts.month.toString() + "-" + ts.day.toString() + "-" + ts.year.toString();

        String time = ts.hour.toString() + ":" + ts.minute.toString();
        String startAddress = data[i]["startLocation"];
        String endAddress = data[i]["endLocation"] ?? " ";
        int seatCount = data[i]["seatsAvailable"];
        List<Map<String, String>> array = [];
        Map<String, String> riders = Map<String, String>.from(data[i]["riderStatus"]);
        riders.forEach((k, v) => {
              print("riders.forEach   $k  $v"),
              array.add({
                "uid": k,
                "status": v,
              })
            });
        print(array);
        print("rider type: " + riders.runtimeType.toString());
        print("riders: $i  " + riders.toString());
        print(i);
        // print(i.toString() + " " + riders.toString());
        String status = riders[uid] ?? " ";
        // print(status);
        double estimatedPrice = double.parse((data[i]["estimatedFare"].toString()));
        String polyLine = data[i]["polyline"];
        // print("polyline: $polyLine");
        bool isOpen = data[i]["isOpen"];
        double estimatedDistance =
            double.parse((data[i]["estimatedDistance"] / 1609).toStringAsFixed(2));
        double estimatedDuration = data[i]["estimatedDistance"] / 60;
        setState(() {
          //trips.clear();
          trips.add(
            RiderTrip(
              tripId: tripId,
              date: date,
              time: time,
              fromAddress: startAddress,
              status: status,
              toAddress: endAddress,
              estimatedPrice: estimatedPrice,
              driverId: driverId,
              isOpen: isOpen,
              polyLine: polyLine,
              seatNumbers: seatCount,
              estimatedDistance: estimatedDistance,
              estimatedDuration: estimatedDuration,
              estimatedFare: estimatedPrice,
              driver: driver,
            ),
          );
        });
      }
      EasyLoading.dismiss();
      return;
    } catch (e) {
      print(e.toString());
      EasyLoading.dismiss();
      setState(() {
        trips.clear();
      });
      return;
    }
  }

  // static scheduled trips list
  // TODO: API call to get scheduled trips map/...
  List<RiderTrip> trips = [];
  //   RiderTrip(
  //     tripId: "1",
  //     date: "01/01/2021",
  //     time: "04:30 PM",
  //     fromAddress: "1111 S Semoran Blvd, 1111, winter park, fl, apt # 111 ",
  //     status: "Pending",
  //     toAddress: "very long address that I cannot wrap unless I add an expanded widget",
  //     estimatedPrice: 32.34,
  //     driverId: "23344",
  //     isOpen: true,
  //     polyLine: "polyLine",
  //     seatNumbers: 4,
  //     estimatedDistance: 111,
  //     estimatedDuration: 111,
  //     estimatedFare: 11,
  //     driver: new User(
  //       uid: "939393",
  //       firstName: "Ahmed",
  //       lastName: "Elshetany",
  //       isDriver: true,
  //       isRider: true,
  //       isVerified: true,
  //       rating: 4,
  //       profileURL:
  //           "https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cGhvdG98ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",
  //       phoneNumber: "4074583995",
  //     ),
  //   ),
  //   RiderTrip(
  //     tripId: "1",
  //     date: "01/01/2021",
  //     time: "04:30 PM",
  //     fromAddress: "1111 S Semoran Blvd, 1111, winter park, fl, apt # 111 ",
  //     status: "Pending",
  //     toAddress: "very long address that I cannot wrap unless I add an expanded widget",
  //     estimatedPrice: 32.34,
  //     driverId: "23344",
  //     isOpen: true,
  //     polyLine: "polyLine",
  //     seatNumbers: 4,
  //     estimatedDistance: 111,
  //     estimatedDuration: 111,
  //     estimatedFare: 11,
  //     driver: new User(
  //       uid: "939393",
  //       firstName: "Ahmed",
  //       lastName: "Elshetany",
  //       isDriver: true,
  //       isRider: true,
  //       isVerified: true,
  //       rating: 4,
  //       profileURL:
  //           "https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cGhvdG98ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",
  //       phoneNumber: "4074583995",
  //     ),
  //   ),
  //   RiderTrip(
  //     tripId: "1",
  //     date: "01/01/2021",
  //     time: "04:30 PM",
  //     fromAddress: "1111 S Semoran Blvd, 1111, winter park, fl, apt # 111 ",
  //     status: "Pending",
  //     toAddress: "very long address that I cannot wrap unless I add an expanded widget",
  //     estimatedPrice: 32.34,
  //     driverId: "23344",
  //     isOpen: true,
  //     polyLine: "polyLine",
  //     seatNumbers: 4,
  //     estimatedDistance: 111,
  //     estimatedDuration: 111,
  //     estimatedFare: 11,
  //     driver: new User(
  //       uid: "939393",
  //       firstName: "Ahmed",
  //       lastName: "Elshetany",
  //       isDriver: true,
  //       isRider: true,
  //       isVerified: true,
  //       rating: 4,
  //       profileURL:
  //           "https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cGhvdG98ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",
  //       phoneNumber: "4074583995",
  //     ),
  //   ),
  //   RiderTrip(
  //     tripId: "1",
  //     date: "01/01/2021",
  //     time: "04:30 PM",
  //     fromAddress: "1111 S Semoran Blvd, 1111, winter park, fl, apt # 111 ",
  //     status: "Pending",
  //     toAddress: "very long address that I cannot wrap unless I add an expanded widget",
  //     estimatedPrice: 32.34,
  //     driverId: "23344",
  //     isOpen: true,
  //     polyLine: "polyLine",
  //     seatNumbers: 4,
  //     estimatedDistance: 111,
  //     estimatedDuration: 111,
  //     estimatedFare: 11,
  //     driver: new User(
  //       uid: "939393",
  //       firstName: "Ahmed",
  //       lastName: "Elshetany",
  //       isDriver: true,
  //       isRider: true,
  //       isVerified: true,
  //       rating: 4,
  //       profileURL:
  //           "https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cGhvdG98ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",
  //       phoneNumber: "4074583995",
  //     ),
  //   ),
  // ];

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
                  // TODO: API call to delete scheduled trip
                  trips.removeAt(index);
                },
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm Trip Cancellation"),
                        content: Text(
                          "Are you sure you wish to cancel your trip?",
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
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Start Ride"),
                              content: Text(
                                "Are you sure you wish to start this ride?",
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
                                    // TODO: Handle start ride
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
                      child: RideContainer(
                        trip: trip,
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, ScheduleScreen.id);
        },
        child: Icon(
          Icons.add,
          size: size.FONT_SIZE * 35,
        ),
        backgroundColor: kButtonColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
