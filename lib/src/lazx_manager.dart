import 'package:lazx/lazx.dart';

/// [LazxManager] represent a manager that will handle your data inside your app.
///
/// A manager could be implement in many ways, this one helps you to observe the
/// data from your repositories (or other data sources) that will have LazxObserver
/// to observe.
abstract class LazxManager {
  /// Represents the list of the [LazxObserver] in your manager
  ///
  /// This variable is used to handle the lifecycle of your observer and dispose
  /// them when your manager is disposed (when tied to your [LazxApp] widget).
  List<LazxObserver> get props;

  LazxManager() {
    init();
  }

  /// Can be override to initialise some calls or variables
  void init() {}

  /// Can be override to finish some calls/listeners
  /// It's also used to dispose all the [LazxObserver]
  void dispose() {
    props.forEach((value) => value.dispose());
  }
}
