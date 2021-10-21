import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mobile_app/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final auth.FirebaseAuth _auth;
  Auth(this._auth);

  Future<User?> userFromFirebase(auth.User? user) async {
    if (user == null)
      return null;
    else {
      final prefs = await SharedPreferences.getInstance();
      final String role = prefs.getString('role') ?? "norole";
      if (role == 'norole') return null;
      ;
      bool isDriver = role == 'driver';
      final obj = <String, dynamic>{
        "uid": user.uid,
        "driver": isDriver,
      };
      String email = user.email ?? "";
      HttpsCallable getUser = FirebaseFunctions.instance.httpsCallable.call('account-getUser');
      final result = await getUser(obj);
      print("user from auth: " + result.data.toString());
      String firstName = result.data['firstName'] ?? "";
      String lastName = result.data['lastName'] ?? "";
      String phone = result.data['phone'] ?? "";
      String url = result.data['profileURL'] ?? "";
      // double weight = (json['weight'] as num).toDouble();
      double rating;
      if (isDriver)
        rating = (result.data['driverRating'] as num).toDouble();
      else
        rating = (result.data['riderRating'] as num).toDouble();
      print("rating from auth");
      print(rating);
      print(rating.runtimeType);
      var riderRole = result.data['roles']['Rider'] ?? false;
      var driverRole = result.data["roles"]["Driver"] ?? false;
      return User(
        uid: user.uid,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phone,
        profileURL: url,
        rating: rating,
        isVerified: user.emailVerified,
        isDriver: driverRole,
        isRider: riderRole,
        email: email,
      );
    }
  }

  //How to call these functions?
  //answer: context.read<Auth>().functionName(param);

  //sign in
  Future<User?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return await userFromFirebase(credential.user);
  }

  //register
  Future<String?> signup(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await credential.user!.sendEmailVerification();
    return credential.user!.uid;
  }

  //reset password
  Future<void> sendResetPasswordEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // sign out
  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', "norole");
  }

  // current user
  Future<User?> currentUser() async {
    return await userFromFirebase(_auth.currentUser);
  }

  sendEmailVerificagtion() async {
    await _auth.currentUser!.sendEmailVerification();
  }

  //update email
  Future<void> updateEmail(String email) async {
    await _auth.currentUser!.updateEmail(email);
    // print(_auth.currentUser!.email);
    await _auth.currentUser!.sendEmailVerification();
  }

  // auth change user stream
  Stream<Future<User?>?> get user => _auth.authStateChanges().map(userFromFirebase);
}
