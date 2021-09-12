import 'package:flutter/material.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/Size.dart';
import 'TopDrawer.dart';

class DriverDrawer extends StatelessWidget {
  DriverDrawer({
    required this.user,
    Key? key,
  }) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    final int rating = user.rating; // change to double later
    final String uName = user.firstName + " " + user.lastName;
    final String imageLink = user.profileURL;
    Size size = Size(Context: context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: size.BLOCK_HEIGHT * 45,
            child: TopDrawer(
              starRating: rating,
              fullName: uName,
              profilePic: imageLink,
            ),
          ),
          Container(
            height: 8,
            color: kDrawerColor,
          ),
          Container(
            color: kDrawerColor,
            child: ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    color: kWhite,
                    size: 40,
                  ),
                  SizedBox(width: 25),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontFamily: 'Glory',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: kWhite,
                    ),
                  ),
                ],
              ),
              onTap: () {
                // TODO: Navigate to vehicle info
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            height: 8,
            color: kDrawerColor,
          ),
          Container(
            color: kDrawerColor,
            child: ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.emoji_transportation,
                    color: kWhite,
                    size: 40,
                  ),
                  SizedBox(width: 25),
                  Text(
                    'Vehicle Information',
                    style: TextStyle(
                      fontFamily: 'Glory',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: kWhite,
                    ),
                  ),
                ],
              ),
              onTap: () {
                // TODO: Navigate to vehicle info
                Navigator.pop(context);
              },
            ),
          ),
          //SizedBox(height: 8),
          Container(
            height: 8,
            color: kDrawerColor,
          ),
          Container(
            color: kDrawerColor,
            child: ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.credit_card_outlined,
                    color: kWhite,
                    size: 40,
                  ),
                  SizedBox(width: 25),
                  Text(
                    'Bank Information',
                    style: TextStyle(
                      fontFamily: 'Glory',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: kWhite,
                    ),
                  ),
                ],
              ),
              onTap: () {
                // TODO: Navigate to bank info
                Navigator.pop(context);
              },
            ),
          ),
          // SizedBox(height: 8),
          Container(
            height: 8,
            color: kDrawerColor,
          ),
          Container(
            color: kDrawerColor,
            child: ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: kWhite,
                    size: 40,
                  ),
                  SizedBox(width: 25),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'Glory',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: kWhite,
                    ),
                  ),
                ],
              ),
              onTap: () {
                // TODO: Logout functionality
                Navigator.pop(context);
              },
            ),
          ),
          //SizedBox(height: 8),
          Container(
            height: 8,
            color: kDrawerColor,
          ),
          Container(
            color: kDrawerColor,
            child: ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                    size: 40,
                  ),
                  SizedBox(width: 25),
                  Text(
                    'Delete Account',
                    style: TextStyle(
                      fontFamily: 'Glory',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              onTap: () {
                // TODO: Alert deletion, then delete or cancel
                Navigator.pop(context);
              },
            ),
          ),
          // SizedBox(height: 8,),
          Container(
            height: 8,
            color: kDrawerColor,
          ),
          Column(
            children: [
              Container(
                color: kDrawerColor,
                height: size.BLOCK_HEIGHT * 25,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
