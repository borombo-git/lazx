import 'package:lazx/lazx.dart';

/// [LazxListenerBuilder] is a type for a builder function that have a
/// [LxState] as a parameter
typedef LazxListenerBuilder = void Function(LxState value);

/// A [LazxListener] is a listener that will call a function depending on
/// the [LxState] of the [data].
class LazxListener {
  /// The [data] that will be listened to execute the [builder] function
  final LazxState data;

  /// The builder function that will be called each time the [data] is updated
  /// They're all optional, if none is provided, nothing will be called
  final LazxListenerBuilder? initial;
  final LazxListenerBuilder? loading;
  final LazxListenerBuilder? success;
  final LazxListenerBuilder? error;

  LazxListener(
      {required this.data,
      this.initial,
      this.loading,
      this.success,
      this.error}) {
    /// We listen to the data's state and calling the right listener builder
    /// function
    data.state.listen((state) {
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
}
