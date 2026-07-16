import 'dart:async';

/// [LazxSubscriptions] tracks stream subscriptions so they can be cancelled
/// in one call when the owner is disposed.
///
/// Mixed into [LazxViewModel] and [LazxManager]: subscribe with [listenTo]
/// instead of calling `stream.listen()` directly and the subscription is
/// automatically cancelled on `dispose()` — no need to store a
/// [StreamSubscription] field per listener.
///
/// ```dart
/// class HomeViewModel extends LazxViewModel {
///   void init() {
///     listenTo(UserManager().user.stream, (user) => name.push(user.name));
///   }
///   // No dispose() override needed for the subscription.
/// }
/// ```
mixin LazxSubscriptions {
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  /// Listens to [stream] and registers the subscription for automatic
  /// cancellation when [cancelSubscriptions] runs (called by `dispose()`).
  ///
  /// Returns the [StreamSubscription] for callers that want to pause or
  /// cancel it earlier themselves.
  StreamSubscription<T> listenTo<T>(
    Stream<T> stream,
    void Function(T value) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final subscription = stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
    _subscriptions.add(subscription);
    return subscription;
  }

  /// Cancels every subscription registered via [listenTo].
  ///
  /// Called automatically by the owner's `dispose()`; safe to call more
  /// than once.
  void cancelSubscriptions() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}
