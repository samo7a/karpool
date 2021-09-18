// wait till you figure out the user objec comming from the backedn
class Trip {
  final String id;
  final String date;
  final String time;
  final String fromAddress;
  final String toAddress;
  final String status;
  final double estimatedPrice;

  Trip({
    required this.date,
    required this.fromAddress,
    required this.id,
    required this.status,
    required this.time,
    required this.toAddress,
    required this.estimatedPrice,
  });

  // api call
  Future<Trip> tripFromFireBase() async {
    return Trip(
      date: "01/01/2021",
      fromAddress: "Address 1",
      id: "1",
      status: "Pending",
      time: "04:30 PM",
      toAddress: "Address 2",
      estimatedPrice: 100,
    );
  }
}
