import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final FirebaseAuth _auth;
  Auth(this._auth);

  //How to call these functions?
  //answer: context.read<Auth>().functionName(param);

  //sign in
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return {"data": user, "msg": ""};
    } on FirebaseAuthException catch (e) {
      return {"msg": e.message, "data": ""};
    }
  }

  // register // handled from the backend
  // Future signup(String email, String password) async {
  //   try {
  //     await _auth.createUserWithEmailAndPassword(email: email, password: password);
  //     return "user";
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   }
  // }

  // sign out
  Future<Map<String, dynamic>> signOut() async {
    try {
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('counter', "norole");
      return {"msg": "", "data": ""};
    } on FirebaseAuthException catch (e) {
      return {"msg": e.message, "data": ""};
    }
  }

  // get current user
  Future<dynamic> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    } else
      return user;
  }

  // auth change user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
