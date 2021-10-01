import 'package:flutter/material.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DriverNavScreen extends StatefulWidget {
  static const String id = 'driverNavigationScreen';

  @override
  _DriverNavScreenState createState() => _DriverNavScreenState();
}

class _DriverNavScreenState extends State<DriverNavScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return Scaffold(
      backgroundColor: Color(0xff33415C),
      appBar: AppBar(
        backgroundColor: Color(0xff33415C),
        title: Text("Trip Navigation"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: kWhite,
          ),
        ),
      ),
      body: SlidingUpPanel(
        panel: Column(
          children: [
            SizedBox(height: size.BLOCK_HEIGHT,),
            Text(
              'Trip Summary',
              style: TextStyle(
                fontFamily: 'Glory',
                fontWeight: FontWeight.bold,
                fontSize: size.FONT_SIZE * 23,
              ),
            ),
            SizedBox(height: size.BLOCK_HEIGHT * 1.5,),
            Row(
              children: [
                 Column(
                   children: [
                    Text(
                      'Rider',
                      style: TextStyle(
                        fontFamily: 'Glory',
                        fontWeight: FontWeight.bold,
                        fontSize: size.FONT_SIZE * 20,
                      ),
                    ),
                    SizedBox(height: size.BLOCK_HEIGHT),
                    Container(
                      width: size.BLOCK_WIDTH * 16,
                      height: size.BLOCK_HEIGHT * 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: size.BLOCK_WIDTH * 10,),
                Column(
                  children: [
                    Text(
                      'Hussein Noureddine',
                      style: TextStyle(
                        fontFamily: 'Glory',
                        fontWeight: FontWeight.bold,
                        fontSize: size.FONT_SIZE * 20,
                      ),
                    ),
                    SizedBox(height: size.BLOCK_HEIGHT,),
                    RatingBarIndicator(
                      rating: 3.0, 
                      itemCount: 5,
                      itemSize: size.BLOCK_WIDTH * 8,
                      direction: Axis.horizontal,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: kStarsColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: size.BLOCK_HEIGHT * 4),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      'From:' + ' Address 1',
                      style: TextStyle(
                        fontFamily: 'Glory',
                        fontWeight: FontWeight.bold,
                        fontSize: size.FONT_SIZE * 20,
                      ),
                    ),
                    SizedBox(height: size.BLOCK_HEIGHT * 2,),
                    Text(
                      'To:' + ' Address 2',
                      style: TextStyle(
                        fontFamily: 'Glory',
                        fontWeight: FontWeight.bold,
                        fontSize: size.FONT_SIZE * 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: size.BLOCK_WIDTH * 20),
                Column(
                  children: [
                    Text(
                      'Profit',
                      style: TextStyle(
                        fontFamily: 'Glory',
                        fontWeight: FontWeight.bold,
                        fontSize: size.FONT_SIZE * 20,
                      ),
                    ),
                    SizedBox(height: size.BLOCK_HEIGHT * 2,),
                    Text(
                      '\$10',
                      style: TextStyle(
                        fontFamily: 'Glory',
                        fontWeight: FontWeight.bold,
                        fontSize: size.FONT_SIZE * 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        minHeight: size.BLOCK_HEIGHT * 5,
        maxHeight: size.BLOCK_HEIGHT * 30,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size.BLOCK_WIDTH * 5),
          topRight: Radius.circular(size.BLOCK_WIDTH * 5),
        ),
        padding: EdgeInsets.symmetric(horizontal: size.BLOCK_WIDTH * 7.5), 
        margin: EdgeInsets.only(
          left: size.BLOCK_WIDTH * 2,
          right: size.BLOCK_WIDTH * 2,
        ),
      ),
    );
  }
}
