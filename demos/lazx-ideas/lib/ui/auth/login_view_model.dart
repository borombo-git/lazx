import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';
import 'package:lazx_idea/ui/auth/auth_manager.dart';

class LoginViewModel extends LazxViewModel {
  LazxState loginRequest = LazxState();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  @override
  List<LazxObservable> get props => [loginRequest];

  @override
  void init() {
    super.init();
    AuthManager().authenticated.observer.listen((authenticated) {
      if (authenticated) {
        loginRequest.setState(LxState.Success);
      }
    });
  }

  Future<void> signUp() async {
    final response = await AuthManager()
        .signUp(emailTextController.text, passwordTextController.text);
    if (!response.success) {
      loginRequest.setState(LxState.Error);
    }
  }
}
