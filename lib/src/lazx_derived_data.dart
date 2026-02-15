import 'dart:async';

import 'package:lazx/src/lazx_data.dart';

/// A read-only [LazxData] that derives its value from a transformed source stream.
///
/// Created by the stream operator extensions on [LazxData]:
/// [debounced], [throttled], and [distinct].
///
/// Calling [push], [reset], or [setState] on a derived data will throw
/// an [UnsupportedError] — update the source [LazxData] instead.
class LazxDerivedData<T> extends LazxData<T> {
  /// Guards against the super constructor calling [push]/[setState].
  /// While false, those calls delegate to super. Once true, they throw.
  bool _isDerived = false;

  /// Temporarily set to true when processing source stream emissions.
  /// Allows [push]/[setState] to delegate to super during internal updates.
  bool _isUpdatingFromSource = false;

  StreamSubscription<T>? _valueSubscription;
  StreamSubscription<LxState>? _stateSubscription;

  /// Creates a derived data container.
  ///
  /// [initialValue] seeds the BehaviorSubject via super constructor.
  /// [sourceValueStream] is the transformed value stream to subscribe to.
  /// [sourceStateStream] forwards state changes from the source as-is.
  LazxDerivedData({
    required T initialValue,
    required Stream<T> sourceValueStream,
    required Stream<LxState> sourceStateStream,
  }) : super(initialValue) {
    _isDerived = true;

    _valueSubscription = sourceValueStream.listen((value) {
      _isUpdatingFromSource = true;
      super.push(value);
      _isUpdatingFromSource = false;
    });

    _stateSubscription = sourceStateStream.listen((state) {
      _isUpdatingFromSource = true;
      super.setState(state);
      _isUpdatingFromSource = false;
    });
  }

  @override
  void push(T newValue, {LxState? lxState}) {
    if (!_isDerived || _isUpdatingFromSource) {
      super.push(newValue, lxState: lxState);
      return;
    }
    throw UnsupportedError(
      'Cannot push to a derived LazxData. Update the source instead.',
    );
  }

  @override
  void setState(LxState lxState) {
    if (!_isDerived || _isUpdatingFromSource) {
      super.setState(lxState);
      return;
    }
    throw UnsupportedError(
      'Cannot setState on a derived LazxData. Update the source instead.',
    );
  }

  @override
  void reset() {
    throw UnsupportedError(
      'Cannot reset a derived LazxData. Update the source instead.',
    );
  }

  @override
  void dispose() {
    _valueSubscription?.cancel();
    _stateSubscription?.cancel();
    super.dispose();
  }
}
