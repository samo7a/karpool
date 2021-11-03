import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TopDrawer extends StatelessWidget {
  const TopDrawer({
    Key? key,
  }) : super(key: key);

  // final String profilePic;
  // final String fullName;
  // final double starRating; //change to double later

  @override
  Widget build(BuildContext context) {
    Size size = new Size(Context: context);
    final user = Provider.of<User>(context, listen: false);
    return DrawerHeader(
      decoration: BoxDecoration(
        color: kDrawerColor,
      ),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Text(
              'Profile Management',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                letterSpacing: 0.5,
                fontSize: size.FONT_SIZE * 20,
                color: kWhite,
              ),
            ),
          ),
          Center(
            child: Container(
              width: size.BLOCK_WIDTH * 32,
              height: size.BLOCK_HEIGHT * 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    user.profileURL,
                    scale: 1,
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Center(
                child: Text(
                  user.firstName + " " + user.lastName,
                  style: TextStyle(
                    fontFamily: 'Glory',
                    fontSize: size.FONT_SIZE * 24,
                    fontWeight: FontWeight.bold,
                    color: kWhite,
                  ),
                ),
              ),
              SizedBox(height: size.BLOCK_HEIGHT * 1),
            ],
          ),
          Center(
            child: RatingBarIndicator(
              rating: user.rating,
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
