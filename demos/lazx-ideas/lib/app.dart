import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';
import 'package:lazx_idea/common/theme.dart';
import 'package:lazx_idea/ui/auth/auth_manager.dart';
import 'package:lazx_idea/ui/auth/login_screen.dart';
import 'package:lazx_idea/ui/home_screen.dart';

class StarterApp extends LazxApp {
  @override
  List<LazxManager> get managers => [AuthManager()];

  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lazx Ideas',
      theme: theme,
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigator,
      home: LazxObserverBuilder<bool>(
        data: AuthManager().authenticated,
        builder: (authenticated) {
          print('Called nav');
          if (authenticated != null && authenticated) {
            //return HomeScreen();
            if (_navigator.currentState != null) {
              _navigator.currentState!.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                  (route) => false);
            }
          } else {
            //return LoginScreen();
            if (_navigator.currentState != null) {
              _navigator.currentState!.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false);
            }
          }
        },
      ),
    );
  }
}
