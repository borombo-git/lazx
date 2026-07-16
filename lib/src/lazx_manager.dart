import 'package:lazx/lazx.dart';

/// [LazxManager] represent a manager that will handle your data inside your app.
///
/// A manager could be implement in many ways, this one helps you to observe the
/// data from your repositories (or other data sources) that will have LazxObserver
/// to observe.
abstract class LazxManager with LazxSubscriptions {
  /// Represents the list of reactive properties in your manager
  ///
  /// This variable is used to handle the lifecycle of your data and dispose
  /// them when your manager is disposed (when tied to your [LazxApp] widget).
  /// Accepts any Lazx reactive type ([LazxObserver], [LazxData], [LazxState]).
  List<LazxDisposable> get props;

  LazxManager() {
    init();
  }

  /// Can be override to initialise some calls or variables
  void init() {}

  /// Can be override to finish some calls/listeners
  /// It's also used to dispose all the [LazxObserver] and cancel every
  /// subscription registered via [listenTo]
  void dispose() {
    cancelSubscriptions();
    props.forEach((value) => value.dispose());
  }
}
