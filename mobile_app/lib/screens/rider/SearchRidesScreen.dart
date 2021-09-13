import 'package:flutter/material.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/TripResultContainer.dart';

class SearchRidesScreen extends StatefulWidget {
  static const String id = 'searchRidesScreen';
  const SearchRidesScreen({Key? key}) : super(key: key);

  @override
  _SearchRidesScreenState createState() => _SearchRidesScreenState();
}

class _SearchRidesScreenState extends State<SearchRidesScreen> {
  String dateTime = "";
  String startLoc = 'Address 1';
  String destination = 'Address 2';

  // static scheduled rides list
  List<Map<String, String>> trips = [
    {
      "tripID": "1",
      "tripDate": "01/01/2021",
      "tripTime": "04:30 PM",
      "from": "Address 1",
      "to": "Address 2",
      "price": "32",
      "imageLink":
          "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
    },
    {
      "tripID": "2",
      "tripDate": "01/10/2021",
      "tripTime": "04:30 PM",
      "from": "Address 1",
      "to": "Address 2",
      "price": "45",
      "imageLink":
          "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
    },
    {
      "tripID": "3",
      "tripDate": "01/20/2021",
      "tripTime": "04:30 PM",
      "from": "Address 1",
      "to": "Address 2",
      "price": "12",
      "imageLink":
          "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
    },
    {
      "tripID": "4",
      "tripDate": "01/30/2021",
      "tripTime": "04:30 PM",
      "from": "Address 1",
      "to": "Address 2",
      "price": "17",
      "imageLink":
          "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return Scaffold(
      backgroundColor: kDashboardColor,
      appBar: AppBar(
        backgroundColor: kDashboardColor,
        title: Text(
          'Search for a ride',
          style: TextStyle(
            fontSize: size.FONT_SIZE * 22,
            color: kWhite,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: kWhite,
          ),
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Date and Time",
                  style: TextStyle(
                    fontFamily: 'Glory',
                    fontWeight: FontWeight.bold,
                    fontSize: size.FONT_SIZE * 20,
                    color: kWhite,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: size.BLOCK_HEIGHT,
                ),
                Container(
                  child: TextFormField(
                    // TODO: Add date & time api for input
                    onChanged: (value) => setState(() => dateTime = value),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Ex: 01/01/2021 04:30 PM",
                      hintStyle: TextStyle(fontSize: size.FONT_SIZE * 19),
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                  height: size.BLOCK_HEIGHT * 6,
                  width: size.BLOCK_WIDTH * 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: kWhite,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.BLOCK_HEIGHT * 3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Start Location",
                  style: TextStyle(
                    fontFamily: 'Glory',
                    fontWeight: FontWeight.bold,
                    fontSize: size.FONT_SIZE * 20,
                    color: kWhite,
                  ),
                ),
                SizedBox(
                  height: size.BLOCK_HEIGHT,
                ),
                Container(
                  child: TextFormField(
                    // TODO: Add address api --> maps/google for input
                    onChanged: (value) => setState(() => startLoc = value),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Ex: 123 Sesame Street",
                      hintStyle: TextStyle(fontSize: size.FONT_SIZE * 19),
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                  height: size.BLOCK_HEIGHT * 6,
                  width: size.BLOCK_WIDTH * 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: kWhite,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.BLOCK_HEIGHT * 3,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Destination",
                  style: TextStyle(
                    fontFamily: 'Glory',
                    fontWeight: FontWeight.bold,
                    fontSize: size.FONT_SIZE * 20,
                    color: kWhite,
                  ),
                ),
                SizedBox(
                  height: size.BLOCK_HEIGHT,
                ),
                Container(
                  child: TextFormField(
                    // TODO: Add address api --> maps/google for input
                    onChanged: (value) => setState(() => destination = value),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Ex: 456 Sesame Street",
                      hintStyle: TextStyle(fontSize: size.FONT_SIZE * 19),
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                  height: size.BLOCK_HEIGHT * 6,
                  width: size.BLOCK_WIDTH * 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: kWhite,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.BLOCK_HEIGHT * 3,
            ),
            // ignore: deprecated_member_use
            FlatButton(
              minWidth: size.BLOCK_WIDTH * 40,
              height: size.BLOCK_HEIGHT * 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              color: Colors.green,
              child: Text(
                'Search Rides',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.FONT_SIZE * 22,
                ),
              ),
              onPressed: () {
                // TODO: Link search to backend & retrieve trips map/data
                //Navigator.pushNamed(context, ''.id);
              },
            ),
            SizedBox(
              height: size.BLOCK_HEIGHT * 5,
            ),
            Text(
              "Search Results:",
              style: TextStyle(
                  //fontFamily: 'Glory',
                  //fontWeight: FontWeight.bold,
                  color: kWhite,
                  fontSize: size.FONT_SIZE * 28),
            ),
            // TODO: Fix list view, possibly put on another screen...
            // ListView.builder(
            //   itemCount: trips.length,
            //   physics: NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   itemBuilder: (BuildContext context, int index) {
            //     return Container(
            //       child: Center(
            //         child: TripResultContainer(
            //           date: trips[index]['tripDate'] ?? "",
            //           time: trips[index]['tripTime'] ?? "",
            //           fromAddress: trips[index]['from'] ?? "",
            //           toAddress: trips[index]['to'] ?? "",
            //           estimatedPrice: trips[index]['price'] ?? "",
            //           profilePic: trips[index]['imageLink'] ?? "",
            //           TODO: add button for scheduling ride
            //         ),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
