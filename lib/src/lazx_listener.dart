import 'dart:async';

import 'package:lazx/lazx.dart';

/// [LazxListenerBuilder] is a type for a builder function that have a
/// [LxState] as a parameter
typedef LazxListenerBuilder = void Function(LxState value);

/// A [LazxListener] is a listener that will call a function depending on
/// the [LxState] of the [data].
///
/// Call [dispose] when the listener is no longer needed to cancel the
/// underlying stream subscription.
class LazxListener {
  /// The [data] that will be listened to execute the [builder] function
  final LazxState data;

  /// The builder function that will be called each time the [data] is updated
  /// They're all optional, if none is provided, nothing will be called
  final LazxListenerBuilder? initial;
  final LazxListenerBuilder? loading;
  final LazxListenerBuilder? success;
  final LazxListenerBuilder? error;

  /// Subscription to the state stream, canceled on [dispose]
  StreamSubscription<LxState>? _subscription;

  LazxListener(
      {required this.data,
      this.initial,
      this.loading,
      this.success,
      this.error}) {
    /// We listen to the data's state and calling the right listener builder
    /// function
    _subscription = data.state.listen((state) {
      switch (state) {
        case LxState.Initial:
          initial?.call(state);
          break;
        case LxState.Loading:
          loading?.call(state);
          break;
        case LxState.Success:
          success?.call(state);
          break;
        case LxState.Error:
          error?.call(state);
          break;
      }
    });
  }

  /// Cancels the state stream subscription.
  /// Must be called when the listener is no longer needed to avoid leaks.
  void dispose() {
    _subscription?.cancel();
  }
}
