import 'package:flutter/material.dart';

class Rider with ChangeNotifier {
  String _firstName = '';

  String get firstName => _firstName;

  // set firstName(String firstName) {
  //   _firstName = firstName;
  // }
  String _lastName = '';

  String get lastName => _lastName;

  // set lastName(String lastName) {
  //   _lastName = lastName;
  // }
}
