import 'package:flutter/material.dart';
import 'package:lazx/src/lazx_manager.dart';

abstract class LazxApp extends StatefulWidget {
  List<LazxManager> get managers;

  /// Could be override to be used in the state of your widget
  void dispose(BuildContext context) {}

  void init(BuildContext context) {}

  /// This build function will replace the classic [build]
  Widget build(BuildContext context);

  @override
  LazxAppState createState() => LazxAppState();
}

class LazxAppState extends State<LazxApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    widget.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context);
  }

  void disposeManagers() {
    widget.managers.forEach((manager) => manager.dispose());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      disposeManagers();
    }
  }

  @override
  void dispose() {
    widget.dispose(context);
    disposeManagers();
    super.dispose();
  }
}
