import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidePanel extends StatelessWidget {
  const SlidePanel({
    Key? key, 
    required this.title, 
    required this.role,
    required this.profileURL,
    required this.fullname,
    required this.rating,
    required this.source,
    required this.destination, 
    required this.money,
  }) : super(key: key);

  final String title;
  final String role;
  final String profileURL;
  final String fullname;
  final double rating;
  final String source;
  final String destination;
  final double money;

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return SlidingUpPanel(
      panel: Column(
        children: [
          SizedBox(
            height: size.BLOCK_HEIGHT,
          ),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Glory',
              fontWeight: FontWeight.bold,
              fontSize: size.FONT_SIZE * 23,
            ),
          ),
          SizedBox(
            height: size.BLOCK_HEIGHT * 1.5,
          ),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    role,
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
                          profileURL
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: size.BLOCK_WIDTH * 10,
              ),
              Column(
                children: [
                  Text(
                    fullname,
                    style: TextStyle(
                      fontFamily: 'Glory',
                      fontWeight: FontWeight.bold,
                      fontSize: size.FONT_SIZE * 20,
                    ),
                  ),
                  SizedBox(
                    height: size.BLOCK_HEIGHT,
                  ),
                  RatingBarIndicator(
                    rating: rating,
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
                    'From: ' + source,
                    style: TextStyle(
                      fontFamily: 'Glory',
                      fontWeight: FontWeight.bold,
                      fontSize: size.FONT_SIZE * 20,
                    ),
                  ),
                  SizedBox(
                    height: size.BLOCK_HEIGHT * 2,
                  ),
                  Text(
                    'To: ' + destination,
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
                  SizedBox(
                    height: size.BLOCK_HEIGHT * 2,
                  ),
                  Text(
                    '\$$money',
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
      maxHeight: size.BLOCK_HEIGHT * 32,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(size.BLOCK_WIDTH * 5),
        topRight: Radius.circular(size.BLOCK_WIDTH * 5),
      ),
      padding: EdgeInsets.symmetric(horizontal: size.BLOCK_WIDTH * 7.5),
      margin: EdgeInsets.only(
        left: size.BLOCK_WIDTH * 2,
        right: size.BLOCK_WIDTH * 2,
      ),
    );
  }
}
