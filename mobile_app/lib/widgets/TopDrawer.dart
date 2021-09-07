import 'package:mobile_app/util/Size.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/pallete.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TopDrawer extends StatelessWidget {
  const TopDrawer({
    Key? key,
    required this.size,
    required this.profilePic,
    required this.fullName,
    required this.starRating
  }) : super(key: key);

  final Size size;
  final String profilePic;
  final String fullName;
  final double starRating;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: kDrawerColor,
      ),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(
              'Profile Management',
              style: TextStyle(
                fontFamily: 'Poppins',
                letterSpacing: 0.5,
                fontSize: 22,
                color: kWhite,
              ),
            ),
          ),
          //SizedBox(height: size.BLOCK_HEIGHT * 2),
          Center(
            child: Container(
              width: size.BLOCK_WIDTH * 30,
              height: size.BLOCK_HEIGHT * 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    profilePic,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          //SizedBox(width: size.BLOCK_WIDTH * 8),
          Column(
            children: [
              Center(
                child: Text(
                  fullName,
                  style: TextStyle(
                    fontFamily: 'Glory',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: kWhite,
                  ),
                ),
              ),
              SizedBox(height: 5),
            ],
          ),
          // SizedBox(height: size.BLOCK_HEIGHT * 2),
          Center(
            child: RatingBarIndicator(
              rating: starRating,
              itemCount: 5,
              itemSize: size.BLOCK_WIDTH * 12,
              direction: Axis.horizontal,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: kStarsColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
