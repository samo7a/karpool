// wait till you figure out the user objec comming from the backedn
class DriverTrip {
  final String tripId;
  final String driverId;
  final String date;
  final String time;
  final String fromAddress;
  final String toAddress;
  final double estimatedPrice;
  final bool isOpen;
  final String polyLine;
  final int seatNumbers;
  final double estimatedDistance;
  final double estimatedDuration;
  final double estimatedFare;
  final dynamic timestamp;
  final List<Map<String, String>> riders;
  final List<Map<String, dynamic>> ridersInfo;
  final Map<String, double> startPoint;
  final Map<String, double> endPoint;
  /* 
  [{riderID: jkWHPS6lzSdXxhb4zvezZAvb7Cl2, pickupIndex: 0, dropoffIndex: 0, passengerCount: 1, dropoffLocation: {_latitude: 28.2953051, _longitude: -81.436792}, estimatedFare: 0, pickupLocation: {_latitude: 28.581269, _longitude: -81.3083762}}]
  */

  final dynamic ts;

  DriverTrip({
    required this.tripId,
    required this.date,
    required this.time,
    required this.fromAddress,
    required this.toAddress,
    required this.estimatedPrice,
    required this.driverId,
    required this.isOpen,
    required this.polyLine,
    required this.seatNumbers,
    required this.estimatedDistance,
    required this.estimatedDuration,
    required this.estimatedFare,
    required this.riders,
    required this.timestamp,
    required this.ts,
    required this.ridersInfo,
    required this.startPoint,
    required this.endPoint,
  });
}
