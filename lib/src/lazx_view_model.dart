import '../lazx.dart';

/// [LazxViewModel] represents the base class to extends for your viewModels
///
/// A [LazxViewModel] will mainly help you to handle easily your [LazxData]
/// It can also be used without any [LazxData] as a classic viewModel to integrate in your app
///
/// Lifecycle hooks are called in this order:
/// [init] -> [onResume] / [onPause] (repeated) -> [dispose]
///
/// Manager/stream listeners registered with [listenTo] are cancelled
/// automatically in [dispose].
abstract class LazxViewModel with LazxSubscriptions {
  /// Whether this ViewModel has been disposed.
  /// Useful to guard against async callbacks completing after dispose.
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  /// Represents the list of reactive properties in your viewModel
  ///
  /// This variable is used to handle the lifecycle of your data as your viewModel
  /// is tied to the lifecycle of your Widget.
  /// Accepts any Lazx reactive type ([LazxData], [LazxState], [LazxObserver]).
  List<LazxDisposable> get props;

  /// Can be override to initialise some calls or variables
  void init() {}

  /// Called when the app comes back to the foreground.
  /// Override to refresh data, reconnect sockets, etc.
  void onResume() {}

  /// Called when the app goes to the background.
  /// Override to save state, pause timers, disconnect, etc.
  void onPause() {}

  /// Can be override to finish some calls/listeners
  /// It's also used to dispose all the [LazxData] and cancel every
  /// subscription registered via [listenTo]
  void dispose() {
    _isDisposed = true;
    cancelSubscriptions();
    props.forEach((value) => value.dispose());
  }
}
