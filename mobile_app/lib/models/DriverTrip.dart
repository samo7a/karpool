// wait till you figure out the user objec comming from the backedn
class DriverTrip {
  final String tripId;
  final String driverId;
  // final User driver;
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
  //add list of riders


  DriverTrip({
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
    // required this.driver,
  });

  // api call
}
