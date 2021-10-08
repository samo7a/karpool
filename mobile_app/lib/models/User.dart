import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String uid = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  String profileURL = '';
  // final String dateOfBirth;
  // final String gender;
  bool isDriver = false;
  bool isVerified = false;
  bool isRider = false;
  double rating = 0;
  User({
    required this.uid,
    required this.firstName,
    required this.lastName,
    // required this.dateOfBirth,
    // required this.gender,
    required this.isDriver,
    required this.isRider,
    required this.isVerified,
    required this.rating,
    required this.profileURL,
    required this.email,
    required this.phoneNumber,
  });
  
  String get getUid => uid;
  set setUid(String value) {
    uid = value;
    notifyListeners();
  }

  String get getFirstName => firstName;
  set setFirstName(String value) {
    firstName = value;
    notifyListeners();
  }

  String get getLastName => lastName;
  set setLastName(String value) {
    lastName = value;
    notifyListeners();
  }

  bool get getIsDriver => isDriver;
  set setIsDriver(bool value) {
    isDriver = value;
    notifyListeners();
  }

  bool get getIsRider => isRider;
  set setIsRider(bool value) {
    isRider = value;
    notifyListeners();
  }

  bool get getIsVerified => isVerified;
  set setIsVerified(bool value) {
    isVerified = value;
    notifyListeners();
  }

  double get getRating => rating;
  set setRating(double value) {
    rating = value;
    notifyListeners();
  }

  String get getEmail => email;
  set setEmail(String value) {
    email = value;
    notifyListeners();
  }

  String get getPhoneNumber => phoneNumber;
  set setPhoneNumber(String value) {
    phoneNumber = value;
    notifyListeners();
  }

  String get getProfileURL => profileURL;
  set setProfileURL(String value) {
    profileURL = value;
    notifyListeners();
  }

  static Future<User> getDriverFromFireBase(String uid) async {
    final obj = <String, dynamic>{
      "uid": uid,
      "driver": true,
    };
    HttpsCallable getUser = FirebaseFunctions.instance.httpsCallable.call('account-getUser');
    final result = await getUser(obj);
    print(result.data);
    String firstName = result.data['firstName'] ?? "";
    String lastName = result.data['lastName'] ?? "";
    String phone = result.data['phone'] ?? "";
    String email = "";
    String url = result.data['profileURL'] ?? "";
    double rating = (result.data['driverRating'] as num).toDouble();
    print("rating from user");
    print(rating);
    print(rating.runtimeType);
    var riderRole = result.data['roles']['Rider'] ?? false;
    var driverRole = result.data["roles"]["Driver"] ?? false;
    return User(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phone,
      profileURL: url,
      rating: rating,
      isVerified: true,
      isDriver: driverRole,
      isRider: riderRole,
      email: email,
    );
  }

  static Future<User> getRiderFromFireBase(String uid) async {
    final obj = <String, dynamic>{
      "uid": uid,
      "driver": false,
    };
    HttpsCallable getUser = FirebaseFunctions.instance.httpsCallable.call('account-getUser');
    final result = await getUser(obj);
    String firstName = result.data['firstName'] ?? "";
    String lastName = result.data['lastName'] ?? "";
    String phone = result.data['phone'] ?? "";
    String email = result.data['email'] ?? "";
    String url = result.data['profileURL'] ?? "";
    double rating = (result.data['riderRating'] as num).toDouble();
    var riderRole = result.data['roles']['Rider'] ?? false;
    var driverRole = result.data["roles"]["Driver"] ?? false;
    return User(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phone,
      profileURL: url,
      rating: rating,
      isVerified: true,
      isDriver: driverRole,
      isRider: riderRole,
      email: email,
    );
  }
}
