// wait till you figure out the user objec comming from the backedn

class RiderTrip {
  final String tripId;
  final String driverId;
  final String date;
  final String time;
  final String fromAddress;
  final String toAddress;
  final String status;
  final bool isOpen;
  final String polyLine;
  final int seatNumbers;
  final double estimatedDistance;
  final double estimatedDuration;
  final double estimatedFare;
  final dynamic timestamp;
  final Map<String, double> startPoint;
  final Map<String, double> endPoint;
  final dynamic ts;

  RiderTrip({
    required this.timestamp,
    required this.tripId,
    required this.date,
    required this.time,
    required this.fromAddress,
    required this.status,
    required this.toAddress,
    required this.driverId,
    required this.isOpen,
    required this.polyLine,
    required this.seatNumbers,
    required this.estimatedDistance,
    required this.estimatedDuration,
    required this.estimatedFare,
    required this.startPoint,
    required this.endPoint,
    required this.ts,
  });
}
