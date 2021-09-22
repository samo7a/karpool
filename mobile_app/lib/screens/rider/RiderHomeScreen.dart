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
import 'package:mobile_app/widgets/RiderRideContainer.dart';
import 'package:intl/intl.dart';

class RiderHomeScreen extends StatefulWidget {
  final User user;
  const RiderHomeScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _RiderHomeScreenState createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  User? user;
  // late Future<List<RiderTrip>> trips;
  void initState() {
    super.initState();
    user = widget.user;
    tripFromFireBase();
  }

  Future<List<RiderTrip>> tripFromFireBase() async {
    EasyLoading.show(status: "Loading...");
    String uid = user!.uid;
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
        return tripList;
      }

      for (int i = 0; i < length; i++) {
        String tripId = data[i]["docID"];
        print("trip id :  $tripId");
        String driverId = data[i]["driverID"];
        dynamic timestamp = data[i]["startTime"];
        DateTime ts = Timestamp(timestamp["_seconds"], timestamp["_nanoseconds"]).toDate();

        String date = ts.month.toString() + "-" + ts.day.toString() + "-" + ts.year.toString();
        String time = DateFormat('hh:mm a').format(ts);
        String startAddress = data[i]["startLocation"];
        String endAddress = data[i]["endLocation"] ?? " ";
        int seatCount = data[i]["seatsAvailable"];

        dynamic rider = data[i]["riderStatus"];
        String status = rider[uid];

        double estimatedPrice = double.parse((data[i]["estimatedFare"].toString()));
        String polyLine = data[i]["polyline"];
        bool isOpen = data[i]["isOpen"];
        double estimatedDistance =
            double.parse((data[i]["estimatedDistance"] / 1609).toStringAsFixed(2));
        double estimatedDuration = data[i]["estimatedDistance"] / 60;
        tripList.add(
          RiderTrip(
            timestamp: ts,
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
                                child: Text(
                                  "YES",
                                  style: TextStyle(
                                    fontFamily: 'Glory',
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.FONT_SIZE * 20,
                                  ),
                                ),
                              ),
                              // ignore: deprecated_member_use
                              FlatButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text(
                                  "NO",
                                  style: TextStyle(
                                    fontFamily: 'Glory',
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.FONT_SIZE * 20,
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
                        child: RiderRideContainer(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
