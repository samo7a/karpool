// wait till you figure out the user objec comming from the backedn
import 'User.dart';

class RiderTrip {
  final String tripId;
  final String driverId;
  final User driver;
  final String date;
  final String time;
  final String fromAddress;
  final String toAddress;
  final String status;
  final double estimatedPrice;
  final bool isOpen;
  final String polyLine;
  final int seatNumbers;
  final double estimatedDistance;
  final double estimatedDuration;
  final double estimatedFare;

  RiderTrip({
    required this.tripId,
    required this.date,
    required this.time,
    required this.fromAddress,
    required this.status,
    required this.toAddress,
    required this.estimatedPrice,
    required this.driverId,
    required this.isOpen,
    required this.polyLine,
    required this.seatNumbers,
    required this.estimatedDistance,
    required this.estimatedDuration,
    required this.estimatedFare,
    required this.driver,
  });

  // api call
  Future<RiderTrip> tripFromFireBase() async {
    User driver = await User.getDriverFromFireBase(this.driverId);
    return RiderTrip(
      tripId: "1",
      driverId: "3333",
      date: "01/01/2021",
      fromAddress: "Address 1",
      status: "Pending",
      time: "04:30 PM",
      toAddress: "Address 2",
      estimatedPrice: 100,
      isOpen: true,
      polyLine: "polyLineEncodedString",
      seatNumbers: 3,
      estimatedDistance: 100,
      estimatedDuration: 100,
      estimatedFare: 10.42,
      driver: driver,
    );
  }
}


