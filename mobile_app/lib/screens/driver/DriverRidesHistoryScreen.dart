import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_app/models/DriverTrip.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/widgets/DriverRideContainer.dart';
import 'package:intl/intl.dart';

class DriverRidesHistoryScreen extends StatefulWidget {
  const DriverRidesHistoryScreen({Key? key}) : super(key: key);

  @override
  _DriverRidesHistoryScreenState createState() => _DriverRidesHistoryScreenState();
}

class _DriverRidesHistoryScreenState extends State<DriverRidesHistoryScreen> {
  late Future<List<DriverTrip>> trips;

  Future<List<DriverTrip>> tripFromFireBase() async {
    final obj = <String, bool>{
      "isDriver": true,
    };
    HttpsCallable getTrips = FirebaseFunctions.instance.httpsCallable.call('trip-getCompletedTrips');
    List<DriverTrip> tripList = [];
    final result;
    final data;
    int length;

    try {
      result = await getTrips(obj);
      print(result.data);
      data = result.data;
      length = result.data.length;
      if (length == 0) {
        return tripList;
      }
      print("start for loop");
      for (int i = 0; i < length; i++) {
        String tripId = data[i]["tripID"];
        String driverId = data[i]["driverID"];
        dynamic timestamp = data[i]["startTime"];
        DateTime ts = Timestamp(timestamp["_seconds"], timestamp["_nanoseconds"]).toDate();
        String date = ts.month.toString() + "-" + ts.day.toString() + "-" + ts.year.toString();
        String time = DateFormat('hh:mm a').format(ts);
        String startAddress = data[i]["startAddress"] ?? " ";
        String endAddress = data[i]["endAddress"] ?? " ";
        List<Map<String, dynamic>> ridersInfo = [];
        List<Map<String, String>> riders = [];

        double estimatedPrice = double.parse((data[i]["totalCost"] ?? 0.0).toStringAsFixed(2));

        String polyLine = data[i]["polyline"];
        double estimatedDistance =
            double.parse((data[i]["distance"] / 1609).toStringAsFixed(2));
        double estimatedDuration = data[i]["distance"] / 60;
        Map<String, double> startPoint = {
          "latitude": data[i]["startLocation"]["_latitude"],
          "longitude": data[i]["startLocation"]["_longitude"],
        };
        Map<String, double> endPoint = {
          "latitude": data[i]["endLocation"]["_latitude"],
          "longitude": data[i]["endLocation"]["_longitude"],
        };
        tripList.add(
          DriverTrip(
            tripId: tripId,
            date: date,
            time: time,
            fromAddress: startAddress,
            toAddress: endAddress,
            estimatedPrice: estimatedPrice,
            driverId: driverId,
            isOpen: false,
            polyLine: polyLine,
            seatNumbers: 0,
            estimatedDistance: estimatedDistance,
            estimatedDuration: estimatedDuration,
            estimatedFare: estimatedPrice,
            riders: riders,
            ts: ts,
            timestamp: timestamp,
            ridersInfo: ridersInfo,
            startPoint: startPoint,
            endPoint: endPoint,
          ),
        );
      }
      tripList.sort((a, b) {
        var adate = a.ts; //before -> var adate = a.expiry;
        var bdate = b.ts; //var bdate = b.expiry;
        return bdate.compareTo(adate);
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
  void initState() {
    super.initState();
    trips = tripFromFireBase();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Container(
        color: Color(0xff33415C),
        child: Center(
          child: FutureBuilder<List<DriverTrip>>(
            future: trips,
            builder: (BuildContext context, AsyncSnapshot<List<DriverTrip>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                EasyLoading.dismiss();
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  padding: EdgeInsets.only(bottom: size.BLOCK_HEIGHT * 10),
                  itemBuilder: (BuildContext context, int index) {
                    final trip = snapshot.data![index];
                    return Container(
                      child: Center(
                        child: DriverRideContainer(
                          trip: trip,
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
                EasyLoading.dismiss();
                return Container(
                  child: Center(
                    child: Icon(
                      Icons.mood_bad,
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
      ),
    );
  }
}
