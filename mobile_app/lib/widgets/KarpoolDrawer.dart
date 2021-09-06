import 'package:flutter/material.dart';
import 'package:mobile_app/pallete.dart';

class KarpoolDrawer extends StatelessWidget {
  const KarpoolDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: kButtonColor,
            ),
            child: Text(
              'Profile Management',
              style: TextStyle(
                fontFamily: 'Glory',
                fontSize: 25,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Vehicle Information',
              style: TextStyle(
                fontFamily: 'Glory',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // TODO: Navigate to vehicle info
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Bank Information',
              style: TextStyle(
                fontFamily: 'Glory',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // TODO: Navigate to vehicle info
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Report an Issue',
              style: TextStyle(
                fontFamily: 'Glory',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // TODO: Navigate to vehicle info
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(
                fontFamily: 'Glory',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // TODO: Navigate to vehicle info
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Delete Account',
              style: TextStyle(
                fontFamily: 'Glory',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // TODO: Navigate to vehicle info
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}