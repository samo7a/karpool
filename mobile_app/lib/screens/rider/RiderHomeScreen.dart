import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_app/models/RiderTrip.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/screens/rider/SearchRidesScreen.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/Size.dart';
// import 'package:mobile_app/widgets/ConfiramtionAlert.dart';
import 'package:mobile_app/widgets/RideContainer.dart';
import 'package:uuid/uuid.dart';

class RiderHomeScreen extends StatefulWidget {
  final User user;
  const RiderHomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _RiderHomeScreenState createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  final String tripDate = '01/01/2021';
  final String tripTime = '04:30 PM';
  final String from = 'Address 1';
  final String to = 'Address 2';
  User? user;
  // api call
  Future<List<RiderTrip>> tripFromFireBase() async {
    // User driver = await User.getDriverFromFireBase(th);
    EasyLoading.show(status: "Loading...");
    String uid = user!.uid;
    print("riderId: " + uid);
    final obj = <String, dynamic>{
      "riderID": uid,
    };
    HttpsCallable getTrips = FirebaseFunctions.instance.httpsCallable.call('trip-getRiderTrips');
    List<RiderTrip> tripList = [];
    final result;
    final data;
    int length;
    try {
      result = await getTrips(obj);
      data = result.data;
      length = result.data.length;
      if (length == 0) {
        EasyLoading.dismiss();
        // setState(() {
        //   trips.clear();
        // });
        return tripList;
      }
      // print("lenght: " + length.toString());
      // print(data);
      for (int i = 0; i < length; i++) {
        String tripId = data[i]["docID"];
        print("trip id :  $tripId");
        String driverId = data[i]["driverID"];
        // print("driverId: " + data[i]["driverID"]);
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
        dynamic riders = data[i]["riderStatus"];
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
        //setState(() {
        // trips.clear();
        tripList.add(
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
            // driver: driver,
          ),
        );
        //});
      }
      return tripList;
    } catch (e) {
      print(e.toString());
      return tripList;
    }
  }

  void initState() {
    super.initState();
    user = widget.user;
    //tripFromFireBase();
  }

  // List<RiderTrip> trips = [];
  // static scheduled rides list
  // TODO: API call to get scheduled rides map/...
  // List<RiderTrip> trips = [
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
        child: FutureBuilder<List<RiderTrip>>(
          future: tripFromFireBase(),
          // initialData: [],
          builder: (BuildContext context, AsyncSnapshot<List<RiderTrip>> snapshot) {
            if (snapshot.hasData) {
              EasyLoading.dismiss();
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final trip = snapshot.data![index];
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    key: Key(trip.tripId),
                    onDismissed: (direction) {
                      // TODO: API call to delete scheduled ride
                      snapshot.data!.removeAt(index);
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
                                onPressed: () => {Navigator.of(context).pop(true)},
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
                },
              );
            } else if (snapshot.hasError) {
              EasyLoading.dismiss();
              EasyLoading.showError('Error: ${snapshot.error}');
              return Container();
            } else {
              EasyLoading.show(status: "Loading...");
              return Container();
            }
          },
        ),
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
