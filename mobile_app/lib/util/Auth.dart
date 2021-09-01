import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth;
  Auth(this._auth);

  //How to call these functions?
  //answer: context.read<Auth>().functionName(param);
  //sign in
  Future signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "user";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // register
  Future signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return "user";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // get current user
  Future getCurrentUser() async {
    return _auth.currentUser;
  }

  // auth change user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
