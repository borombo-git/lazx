import 'dart:async';

import 'package:lazx/src/lazx_data.dart';
import 'package:lazx/src/lazx_observable.dart';
import 'package:lazx/src/lazx_observer.dart';
import 'package:lazx/src/lazx_state.dart';

/// A read-only [LazxData] that derives its value from multiple reactive sources.
///
/// `LazxComputed` auto-recomputes whenever any source emits a new value.
/// By default it is **distinct** — if the recomputed value equals the previous
/// one (via `==`), the emission is skipped, avoiding unnecessary widget rebuilds.
///
/// ```dart
/// final firstName = LazxData<String>('John');
/// final lastName = LazxData<String>('Doe');
///
/// final fullName = LazxComputed<String>(
///   sources: [firstName, lastName],
///   compute: () => '${firstName.value} ${lastName.value}',
/// );
///
/// // fullName.value == 'John Doe'
/// firstName.push('Jane');
/// // fullName.value == 'Jane Doe'
/// ```
///
/// The computed data integrates into the `props` list for automatic disposal.
///
/// Calling [push], [setState], or [reset] throws [UnsupportedError] — update
/// the source data instead.
class LazxComputed<T> extends LazxData<T> {
  /// Guards against the super constructor calling [push]/[setState].
  /// While false, those calls delegate to super. Once true, they throw.
  bool _isComputed = false;

  /// Temporarily set to true during internal recomputation.
  /// Allows [push]/[setState] to delegate to super during updates.
  bool _isUpdatingFromCompute = false;

  /// Whether to skip emissions when the computed value hasn't changed.
  final bool _distinct;

  /// The compute function that derives a value from sources.
  final T Function() _compute;

  /// The last computed value, used for distinct comparison.
  T _lastComputedValue;

  /// Tracks the latest state from each observable source.
  final Map<LazxObservable, LxState> _sourceStates = {};

  /// Active subscriptions for cleanup on dispose.
  final List<StreamSubscription> _subscriptions = [];

  /// Creates a computed data container.
  ///
  /// [sources] — the reactive sources to listen to. Supports [LazxData],
  /// [LazxObserver], and [LazxState].
  ///
  /// [compute] — a function that reads source values and returns the
  /// derived value. Called once immediately and then on every source emission.
  ///
  /// [distinct] — when `true` (default), skips pushing the computed value
  /// if it equals the previous one via `==`.
  LazxComputed({
    required List<LazxDisposable> sources,
    required T Function() compute,
    bool distinct = true,
  })  : _compute = compute,
        _distinct = distinct,
        _lastComputedValue = compute(),
        super(compute()) {
    // Phase 1: Subscribe to state streams on LazxObservable sources.
    // BehaviorSubject replays current state synchronously, seeding _sourceStates.
    for (final source in sources) {
      if (source is LazxObservable) {
        _subscriptions.add(
          source.state.listen((state) {
            _sourceStates[source] = state;
            if (_isComputed) {
              _aggregateState();
            }
          }),
        );
      }
    }

    // Phase 2: Subscribe to value streams for recomputation.
    // .skip(1) avoids BehaviorSubject replay since super(compute()) already
    // seeded the initial value.
    for (final source in sources) {
      if (source is LazxData) {
        _subscriptions.add(
          source.stream.skip(1).listen((_) => _recompute()),
        );
      } else if (source is LazxObserver) {
        _subscriptions.add(
          source.stream.skip(1).listen((_) => _recompute()),
        );
      }
      // LazxState has no value stream — state-only contribution handled above.
    }

    // Phase 3: Lock as computed and perform initial state aggregation.
    _isComputed = true;
    _aggregateState();
  }

  /// Recomputes the derived value and pushes it if changed (or not distinct).
  void _recompute() {
    final newValue = _compute();
    if (_distinct && newValue == _lastComputedValue) return;
    _lastComputedValue = newValue;
    _isUpdatingFromCompute = true;
    super.push(newValue);
    _isUpdatingFromCompute = false;
  }

  /// Aggregates the state from all observable sources.
  ///
  /// Priority: Error > Loading > Success > Initial.
  void _aggregateState() {
    if (_sourceStates.isEmpty) return;

    LxState aggregated = LxState.Initial;
    for (final state in _sourceStates.values) {
      if (state == LxState.Error) {
        aggregated = LxState.Error;
        break;
      } else if (state == LxState.Loading) {
        aggregated = LxState.Loading;
      } else if (state == LxState.Success &&
          aggregated != LxState.Loading) {
        aggregated = LxState.Success;
      }
    }

    _isUpdatingFromCompute = true;
    super.setState(aggregated);
    _isUpdatingFromCompute = false;
  }

  @override
  void push(T newValue, {LxState? lxState}) {
    if (!_isComputed || _isUpdatingFromCompute) {
      super.push(newValue, lxState: lxState);
      return;
    }
    throw UnsupportedError(
      'Cannot push to a LazxComputed. Update the source data instead.',
    );
  }

  @override
  void setState(LxState lxState) {
    if (!_isComputed || _isUpdatingFromCompute) {
      super.setState(lxState);
      return;
    }
    throw UnsupportedError(
      'Cannot setState on a LazxComputed. Update the source data instead.',
    );
  }

  @override
  void reset() {
    if (!_isComputed) {
      super.reset();
      return;
    }
    throw UnsupportedError(
      'Cannot reset a LazxComputed. Update the source data instead.',
    );
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    _sourceStates.clear();
    super.dispose();
  }
}
