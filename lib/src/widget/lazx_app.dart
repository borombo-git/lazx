import 'package:flutter/material.dart';
import 'package:lazx/src/lazx_manager.dart';

/// A [LazxApp] is a widget that will represent your entire app.
///
/// This widget will handle the lifecycle of your [LazxManager] so you can access
/// them everywhere at everytime inside your app
///
/// [LazxApp] is not mandatory to use the other Lazx components, it's useful
/// only if you use [LazxManager]'s
///
/// ```dart
/// class MyApp extends LazxApp {
///
///   @override
///   List<LazxManager> get managers => [MyManager()];
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       title: 'Lazx App',
///       theme: theme,
///       home: MyScreen(),
///     );
///   }
/// }
/// ```
abstract class LazxApp extends StatefulWidget {
  /// Represents the list of the [LazxManager] in your App
  ///
  /// This variable is used to handle the lifecycle of your managers with your
  /// app
  List<LazxManager> get managers;

  /// Could be override to be used in the state of your widget
  void dispose(BuildContext context) {}

  void init(BuildContext context) {}

  /// This build function will replace the classic [build]
  Widget build(BuildContext context);

  @override
  LazxAppState createState() => LazxAppState();
}

/// [LazxAppState] Represents the state for the [LazxApp] so you don't have
/// to handle it
class LazxAppState extends State<LazxApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    widget.init(context);
  }

  /// Call the build function of the widget
  @override
  Widget build(BuildContext context) {
    return widget.build(context);
  }

  /// Will call the dispose() function for all the managers
  void disposeManagers() {
    widget.managers.forEach((manager) => manager.dispose());
  }

  /// Listen to app Lifecycle and dispose all the managers when the app is
  /// killed / detached
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      disposeManagers();
    }
  }

  /// Will dispose the state and do the same for all the managers
  @override
  void dispose() {
    widget.dispose(context);
    disposeManagers();
    super.dispose();
  }
}
