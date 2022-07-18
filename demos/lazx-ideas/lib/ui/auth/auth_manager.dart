import 'package:firebase_auth/firebase_auth.dart';
import 'package:lazx/lazx.dart';

import 'auth_repository.dart';

class AuthManager extends LazxManager {
  static AuthManager? _instance;
  factory AuthManager() => _instance ??= AuthManager._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository _authRepository = AuthRepository();

  LazxObserver<bool> authenticated = LazxObserver();

  @override
  List<LazxObserver> get props => [authenticated];

  AuthManager._() {
    _auth.authStateChanges().listen((user) {
      authenticated.set(user != null);
    });
  }

  Future<LxResponse> signUp(String email, String password) async {
    return await _authRepository.signUp(email, password);
  }

  void signIn(String email, String password) {
    _authRepository.signIn(email, password);
  }

  Future<LxResponse> logout() async {
    return await _authRepository.logOut();
  }
}
