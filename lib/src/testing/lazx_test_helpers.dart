import 'dart:async';

import 'package:lazx/lazx.dart';

/// Testing helpers for [LazxObservable] types ([LazxData], [LazxState], [LazxDerivedData]).
///
/// Provides [waitForState] and [expectStateSequence] to simplify async
/// state assertions in tests.
///
/// Import via `package:lazx/lazx_testing.dart` — never bundled in production.
extension LazxObservableTestHelpers on LazxObservable {
  /// Completes when [targetState] is observed on the [state] stream.
  ///
  /// Resolves immediately if the current state already matches.
  /// Throws [TimeoutException] if [timeout] elapses (default 5 s).
  Future<void> waitForState(
    LxState targetState, {
    Duration timeout = const Duration(seconds: 5),
  }) {
    final completer = Completer<void>();
    late StreamSubscription<LxState> sub;

    sub = state.listen((current) {
      if (!completer.isCompleted && current == targetState) {
        sub.cancel();
        completer.complete();
      }
    });

    return completer.future.timeout(timeout, onTimeout: () {
      sub.cancel();
      throw TimeoutException(
        'waitForState($targetState) timed out after $timeout. '
        'No matching state was observed.',
        timeout,
      );
    });
  }

  /// Verifies that the [state] stream emits exactly [expected] in order.
  ///
  /// Strict: throws [StateError] immediately if an unexpected state arrives.
  /// Throws [TimeoutException] if the full sequence is not observed within
  /// [timeout] (default 5 s).
  ///
  /// An empty [expected] list completes immediately.
  Future<void> expectStateSequence(
    List<LxState> expected, {
    Duration timeout = const Duration(seconds: 5),
  }) {
    if (expected.isEmpty) return Future.value();

    final completer = Completer<void>();
    var index = 0;
    late StreamSubscription<LxState> sub;

    sub = state.listen((current) {
      if (completer.isCompleted) return;

      if (current != expected[index]) {
        sub.cancel();
        completer.completeError(StateError(
          'expectStateSequence: expected ${expected[index]} at index $index '
          'but got $current. Full expected sequence: $expected',
        ));
        return;
      }

      index++;
      if (index == expected.length) {
        sub.cancel();
        completer.complete();
      }
    });

    return completer.future.timeout(timeout, onTimeout: () {
      sub.cancel();
      throw TimeoutException(
        'expectStateSequence timed out after $timeout. '
        'Received $index of ${expected.length} expected states. '
        'Expected: $expected',
        timeout,
      );
    });
  }
}

/// Testing helpers for [LazxData].
///
/// Provides [waitForValue] and [expectEmits] to simplify async value
/// assertions in tests.
///
/// Import via `package:lazx/lazx_testing.dart` — never bundled in production.
extension LazxDataTestHelpers<T> on LazxData<T> {
  /// Completes when [targetValue] is observed on the [stream].
  ///
  /// Resolves immediately if the current value already matches (BehaviorSubject replay).
  /// Uses `==` for comparison.
  /// Throws [TimeoutException] if [timeout] elapses (default 5 s).
  Future<void> waitForValue(
    T targetValue, {
    Duration timeout = const Duration(seconds: 5),
  }) =>
      _waitForValueOnStream<T>(stream, targetValue, timeout);

  /// Collects the next [expected].length emissions from [stream] and verifies
  /// they match [expected] in order.
  ///
  /// The BehaviorSubject replay counts as the first emission.
  /// Throws [StateError] if values don't match.
  /// Throws [TimeoutException] if not enough emissions arrive within [timeout].
  ///
  /// An empty [expected] list completes immediately.
  Future<void> expectEmits(
    List<T> expected, {
    Duration timeout = const Duration(seconds: 5),
  }) =>
      _expectEmitsOnStream<T>(stream, expected, timeout);
}

/// Testing helpers for [LazxObserver].
///
/// Provides [waitForValue] and [expectEmits] to simplify async value
/// assertions in tests.
///
/// Import via `package:lazx/lazx_testing.dart` — never bundled in production.
extension LazxObserverTestHelpers<T> on LazxObserver<T> {
  /// Completes when [targetValue] is observed on the [stream].
  ///
  /// Resolves immediately if the current value already matches (BehaviorSubject replay).
  /// Uses `==` for comparison.
  /// Throws [TimeoutException] if [timeout] elapses (default 5 s).
  Future<void> waitForValue(
    T targetValue, {
    Duration timeout = const Duration(seconds: 5),
  }) =>
      _waitForValueOnStream<T>(stream, targetValue, timeout);

  /// Collects the next [expected].length emissions from [stream] and verifies
  /// they match [expected] in order.
  ///
  /// The BehaviorSubject replay counts as the first emission.
  /// Throws [StateError] if values don't match.
  /// Throws [TimeoutException] if not enough emissions arrive within [timeout].
  ///
  /// An empty [expected] list completes immediately.
  Future<void> expectEmits(
    List<T> expected, {
    Duration timeout = const Duration(seconds: 5),
  }) =>
      _expectEmitsOnStream<T>(stream, expected, timeout);
}

// ---------------------------------------------------------------------------
// Private helpers shared between LazxData and LazxObserver extensions
// ---------------------------------------------------------------------------

Future<void> _waitForValueOnStream<T>(
  Stream<T> stream,
  T targetValue,
  Duration timeout,
) {
  final completer = Completer<void>();
  late StreamSubscription<T> sub;

  sub = stream.listen((current) {
    if (!completer.isCompleted && current == targetValue) {
      sub.cancel();
      completer.complete();
    }
  });

  return completer.future.timeout(timeout, onTimeout: () {
    sub.cancel();
    throw TimeoutException(
      'waitForValue($targetValue) timed out after $timeout. '
      'No matching value was observed.',
      timeout,
    );
  });
}

Future<void> _expectEmitsOnStream<T>(
  Stream<T> stream,
  List<T> expected,
  Duration timeout,
) {
  if (expected.isEmpty) return Future.value();

  final completer = Completer<void>();
  final collected = <T>[];
  late StreamSubscription<T> sub;

  sub = stream.listen((value) {
    if (completer.isCompleted) return;

    collected.add(value);

    if (collected.length == expected.length) {
      sub.cancel();
      for (var i = 0; i < expected.length; i++) {
        if (collected[i] != expected[i]) {
          completer.completeError(StateError(
            'expectEmits: mismatch at index $i — '
            'expected ${expected[i]} but got ${collected[i]}. '
            'Collected: $collected, Expected: $expected',
          ));
          return;
        }
      }
      completer.complete();
    }
  });

  return completer.future.timeout(timeout, onTimeout: () {
    sub.cancel();
    throw TimeoutException(
      'expectEmits timed out after $timeout. '
      'Collected ${collected.length} of ${expected.length} emissions. '
      'Collected so far: $collected, Expected: $expected',
      timeout,
    );
  });
}
