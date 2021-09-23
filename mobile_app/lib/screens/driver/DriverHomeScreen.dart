import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_app/models/DriverTrip.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/DriverRideContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ScheduleScreen.dart';
import 'package:intl/intl.dart';

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

  Future<List<DriverTrip>> tripFromFireBase() async {
    String uid = user!.uid;
    final obj = <String, dynamic>{
      "driverID": uid,
    };
    HttpsCallable getTrips = FirebaseFunctions.instance.httpsCallable.call('trip-getDriverTrips');
    List<DriverTrip> tripList = [];
    final result;
    final data;
    int length;
    try {
      result = await getTrips(obj);
      data = result.data;
      length = result.data.length;
      if (length == 0) {
        return tripList;
      }

      for (int i = 0; i < length; i++) {
        String tripId = data[i]["docID"];
        String driverId = data[i]["driverID"];
        dynamic timestamp = data[i]["startTime"];
        DateTime ts = Timestamp(timestamp["_seconds"], timestamp["_nanoseconds"]).toDate();
        String date = ts.month.toString() + "-" + ts.day.toString() + "-" + ts.year.toString();
        String time = DateFormat('hh:mm a').format(ts);
        String startAddress = data[i]["startLocation"];
        String endAddress = data[i]["endLocation"] ?? " ";
        int seatCount = data[i]["seatsAvailable"];

        List<Map<String, String>> riders = [];
        Map<String, String> rider = Map<String, String>.from(data[i]["riderStatus"]);
        rider.forEach((k, v) => {
              riders.add({
                "uid": k,
                "status": v,
              })
            });

        double estimatedPrice = double.parse((data[i]["estimatedFare"].toString()));
        String polyLine = data[i]["polyline"];
        bool isOpen = data[i]["isOpen"];
        double estimatedDistance =
            double.parse((data[i]["estimatedDistance"] / 1609).toStringAsFixed(2));
        double estimatedDuration = data[i]["estimatedDistance"] / 60;
        tripList.add(
          DriverTrip(
            tripId: tripId,
            date: date,
            time: time,
            fromAddress: startAddress,
            toAddress: endAddress,
            estimatedPrice: estimatedPrice,
            driverId: driverId,
            isOpen: isOpen,
            polyLine: polyLine,
            seatNumbers: seatCount,
            estimatedDistance: estimatedDistance,
            estimatedDuration: estimatedDuration,
            estimatedFare: estimatedPrice,
            riders: riders,
            timestamp: ts,
          ),
        );
      }
      tripList.sort((a, b) {
        var adate = a.timestamp; //before -> var adate = a.expiry;
        var bdate = b.timestamp; //var bdate = b.expiry;
        return adate.compareTo(bdate);
      });
      return tripList;
    } catch (e) {
      print(e.toString());
      return tripList;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return RefreshIndicator(
      onRefresh: tripFromFireBase,
      child: Scaffold(
        body: Container(
          color: kDashboardColor,
          child: FutureBuilder<List<DriverTrip>>(
            future: tripFromFireBase(),
            builder: (BuildContext context, AsyncSnapshot<List<DriverTrip>> snapshot) {
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
                        // TODO: API call to delete scheduled trip
                        snapshot.data!.removeAt(index);
                      },
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(size.BLOCK_WIDTH * 7),
                              ),
                              title: Text(
                                "Confirm Trip Cancellation",
                                style: TextStyle(
                                  color: Color(0xffffffff),
                                ),
                              ),
                              content: Text(
                                "Are you sure you want to cancel your trip?",
                                style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontFamily: 'Glory',
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.FONT_SIZE * 22,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Container(
                                    height: size.BLOCK_HEIGHT * 7,
                                    width: size.BLOCK_WIDTH * 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(size.BLOCK_WIDTH * 5),
                                      color: Color(0xff001233),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "No",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xffffffff),
                                          fontFamily: 'Glory',
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.FONT_SIZE * 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: size.BLOCK_WIDTH * 2.5),
                                  child: TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Container(
                                      height: size.BLOCK_HEIGHT * 7,
                                      width: size.BLOCK_WIDTH * 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(size.BLOCK_WIDTH * 5),
                                        color: Color(0xffC80404),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Yes",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xffffffff),
                                            fontFamily: 'Glory',
                                            fontWeight: FontWeight.bold,
                                            fontSize: size.FONT_SIZE * 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              backgroundColor: Color(0xff0353A4),
                            );
                          },
                        );
                      },
                      background: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Delete Trip',
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
                            child: DriverRideContainer(
                              trip: trip,
                            ),
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
            Navigator.pushNamed(context, ScheduleScreen.id);
          },
          child: Icon(
            Icons.add,
            size: size.FONT_SIZE * 35,
          ),
          backgroundColor: kButtonColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
