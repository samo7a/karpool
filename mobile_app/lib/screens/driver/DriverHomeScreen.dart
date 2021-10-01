import 'dart:async';

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
  late Future<List<DriverTrip>> trips;

  void initState() {
    super.initState();
    user = widget.user;
    trips = tripFromFireBase();
  }

  Future<List<DriverTrip>> tripFromFireBase() async {
    String uid = user!.uid;
    final obj = <String, dynamic>{
      "driverID": uid,
    };
    print("obj");
    print(obj);
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
        print("tripId");
        print(tripId);
        String driverId = data[i]["driverID"];
        print("driverId");
        print(driverId);
        dynamic timestamp = data[i]["startTime"];
        print("timestamp");
        print(timestamp);
        DateTime ts = Timestamp(timestamp["_seconds"], timestamp["_nanoseconds"]).toDate();
        print("ts");
        print(ts);
        String date = ts.month.toString() + "-" + ts.day.toString() + "-" + ts.year.toString();
        print("date");
        print(date);
        String time = DateFormat('hh:mm a').format(ts);
        print("time");
        print(time);
        String startAddress = data[i]["startAddress"] ?? " ";
        print("startAddress");
        print(startAddress);
        String endAddress = data[i]["endAddress"] ?? " ";
        print("endAddress");
        print(endAddress);
        int seatCount = data[i]["seatsAvailable"];
        print("seatCount");
        print(seatCount);

        List<Map<String, String>> riders = [];
        Map<String, String> rider = Map<String, String>.from(data[i]["riderStatus"]);
        rider.forEach((k, v) => {
              riders.add({
                "uid": k.toString(),
                "status": v.toString(),
              })
            });

        double estimatedPrice = double.parse((data[i]["estimatedFare"] ?? 0.0).toStringAsFixed(2));

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

  Future _onRefresh() async {
    setState(() {
      trips = tripFromFireBase();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        body: Container(
          color: kDashboardColor,
          child: FutureBuilder<List<DriverTrip>>(
            future: tripFromFireBase(),
            builder: (BuildContext context, AsyncSnapshot<List<DriverTrip>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                EasyLoading.dismiss();
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: size.BLOCK_HEIGHT * 10),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final trip = snapshot.data![index];
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      key: Key(trip.tripId),
                      onDismissed: (direction) async {
                        // TODO: API call to delete scheduled ride
                        EasyLoading.show(status: "Deleting ...");
                        Map<String, String> obj = {
                          "driverID": user!.uid,
                          "tripID": trip.tripId,
                        };
                        HttpsCallable cancelRide =
                            FirebaseFunctions.instance.httpsCallable("trip-deleteRidebyDriver");
                        try {
                          await cancelRide(obj);
                          EasyLoading.dismiss();
                          EasyLoading.showSuccess("Ride Deleted");
                          snapshot.data!.removeAt(index);
                        } catch (e) {
                          EasyLoading.dismiss();
                          EasyLoading.showError(
                              "Error Occured while deleting your ride, Please try agian!");
                          print(e.toString());
                        }
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
                              content: Container(
                                height: size.BLOCK_HEIGHT * 25,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: Colors.yellow,
                                        ),
                                        SizedBox(
                                          width: size.BLOCK_WIDTH * 4,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "If the ride is within 3 hrs before starting time, you will be charged \$5.",
                                            style: TextStyle(
                                              color: Color(0xffffffff),
                                            ),
                                            maxLines: 10,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Are you sure you want to cancel your trip?",
                                      style: TextStyle(
                                        color: Color(0xffffffff),
                                        fontFamily: 'Glory',
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.FONT_SIZE * 22,
                                      ),
                                    ),
                                  ],
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
                                    onPressed: () => Navigator.of(context).pop(true),
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
                            onTap: () async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(size.BLOCK_WIDTH * 7),
                                    ),
                                    title: Text(
                                      "Start Ride",
                                      style: TextStyle(
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    content: Text(
                                      "Are you sure you want to start this ride?",
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
                                            borderRadius:
                                                BorderRadius.circular(size.BLOCK_WIDTH * 5),
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
                                              borderRadius:
                                                  BorderRadius.circular(size.BLOCK_WIDTH * 5),
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
                            child: DriverRideContainer(
                              trip: trip,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
                EasyLoading.dismiss();
                EasyLoading.showError('Error: ${snapshot.error}');
                return Container(
                  child: Center(
                    child: Text(
                      "Empty | No Rides | Edit this | Make it cool",
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                EasyLoading.dismiss();
                EasyLoading.showError('Error: ${snapshot.error}');
                return Container();
              } else if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.active) {
                EasyLoading.show(status: "Loading...");
                return Container();
              } else
                return Container();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result =
                await Navigator.pushNamed(context, ScheduleScreen.id, arguments: user!.uid);
            if (result == null) return;
            trips = tripFromFireBase();
          },
          child: Icon(
            Icons.add,
            size: size.FONT_SIZE * 35,
          ),
          backgroundColor: kButtonColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
