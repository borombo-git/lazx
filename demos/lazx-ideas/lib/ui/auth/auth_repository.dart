import 'package:firebase_auth/firebase_auth.dart';
import 'package:lazx/lazx.dart';

class AuthRepository {
  static AuthRepository? _instance;
  factory AuthRepository() => _instance ??= AuthRepository._();

  AuthRepository._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign up with email & password
  Future<LxResponse> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print(e);
        return LxResponse(error: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print(e);
        return LxResponse(error: 'The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      return LxResponse(error: 'An error occurred. Please try again later');
    }
    return LxResponse(success: true);
  }

  /// Login with email & password
  Future<LxResponse> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print(e);
        return LxResponse(error: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print(e);
        return LxResponse(error: 'Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
      return LxResponse(error: 'An error occurred. Please try again later');
    }
    return LxResponse(success: true);
  }

  /// Sign out
  Future<LxResponse> logOut() async {
    try {
      await _auth.signOut();
      return LxResponse(success: true);
    } on Exception {
      return LxResponse(error: 'An error occurred. Please try again later');
    }
  }
}
