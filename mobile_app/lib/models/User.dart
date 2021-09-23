import 'package:cloud_functions/cloud_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String uid;
  final String firstName;
  final String lastName;
  // final String email;
  final String phoneNumber;
  // final String dateOfBirth;
  // final String gender;
  final bool isDriver;
  final bool isVerified;
  final bool isRider;
  final String profileURL;
  final num rating; // change to double later
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
    // required this.email,
    required this.phoneNumber,
  });
  static Future<User> getDriverFromFireBase(String uid) async {
    final obj = <String, dynamic>{
      "uid": uid,
      "driver": true,
    };
    HttpsCallable getUser = FirebaseFunctions.instance.httpsCallable.call('account-getUser');
    final result = await getUser(obj);
    String firstName = result.data['firstName'] ?? "";
    String lastName = result.data['lastName'] ?? "";
    String phone = result.data['phone'] ?? "";
    String url = result.data['profileURL'] ?? "";
    num rating = result.data['driverRating'] ?? 0.0; //change to 0.0
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
    String url = result.data['profileURL'] ?? "";
    double rating = result.data['riderRating'] as double; //change to 0.0
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
    );
  }
}
// (Ahmed) I will add the other fields later.
