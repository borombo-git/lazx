import 'package:lazx/lazx.dart';

typedef LazxListenerBuilder = void Function(LxState value);

class LazxListener {
  /// The [data] that will be listened to execute the [builder] function
  final LazxState data;

  /// The builder function that will be call each time the [data] is updated,
  /// passing the new value
  final LazxListenerBuilder? initial;
  final LazxListenerBuilder? loading;
  final LazxListenerBuilder? success;
  final LazxListenerBuilder? error;

  LxState currentState = LxState.Initial;

  LazxListener(
      {required this.data,
      this.initial,
      this.loading,
      this.success,
      this.error}) {
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
