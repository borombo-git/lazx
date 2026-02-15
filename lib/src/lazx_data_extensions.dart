import 'package:lazx/src/lazx_data.dart';
import 'package:lazx/src/lazx_derived_data.dart';
import 'package:rxdart/rxdart.dart';

/// Stream operator extensions on [LazxData].
///
/// These return a read-only [LazxDerivedData] that applies common RxDart
/// operators to the source value stream. The derived data works as a drop-in
/// replacement in all Lazx builders.
///
/// ```dart
/// final query = LazxData<String>('');
/// final debouncedQuery = query.debounced(Duration(milliseconds: 300));
///
/// // Use in any builder
/// LazxBuilder<String>(
///   data: debouncedQuery,
///   builder: (context, value) => Text(value ?? ''),
/// )
/// ```
extension LazxDataStreamOperators<T> on LazxData<T> {
  /// Returns a derived [LazxData] that debounces value emissions by [duration].
  ///
  /// The initial value is available immediately. Subsequent values are only
  /// emitted after [duration] has passed with no new values from the source.
  ///
  /// Useful for search fields, form validation, and other inputs where you
  /// want to wait for the user to stop typing before reacting.
  ///
  /// ```dart
  /// final query = LazxData<String>('');
  /// final debounced = query.debounced(Duration(milliseconds: 300));
  /// ```
  LazxDerivedData<T> debounced(Duration duration) {
    return LazxDerivedData<T>(
      initialValue: value,
      // Skip the BehaviorSubject replay — debouncing the initial value
      // is meaningless since it's already provided via initialValue.
      sourceValueStream: stream.skip(1).debounceTime(duration),
      sourceStateStream: state.skip(1),
    );
  }

  /// Returns a derived [LazxData] that throttles value emissions by [duration].
  ///
  /// The first value emits immediately, then subsequent values are ignored
  /// until [duration] has passed. After the window, the next value emits
  /// and a new window starts.
  ///
  /// Useful for scroll events, button taps, and other high-frequency inputs
  /// where you want to limit the rate of processing.
  ///
  /// ```dart
  /// final counter = LazxData<int>(0);
  /// final throttled = counter.throttled(Duration(seconds: 1));
  /// ```
  LazxDerivedData<T> throttled(Duration duration) {
    return LazxDerivedData<T>(
      initialValue: value,
      // Skip the BehaviorSubject replay — the initial value is already
      // captured via initialValue. Only new pushes are throttled.
      sourceValueStream: stream.skip(1).throttleTime(duration),
      sourceStateStream: state.skip(1),
    );
  }

  /// Returns a derived [LazxData] that only emits when the value changes.
  ///
  /// Consecutive duplicate values are skipped. An optional [equals] function
  /// can be provided for custom equality comparison.
  ///
  /// Useful for filtering out redundant updates that would cause unnecessary
  /// widget rebuilds.
  ///
  /// ```dart
  /// final status = LazxData<String>('idle');
  /// final distinctStatus = status.distinct();
  ///
  /// // With custom comparator
  /// final items = LazxData<List<int>>([]);
  /// final distinctItems = items.distinct(
  ///   (a, b) => a.length == b.length,
  /// );
  /// ```
  LazxDerivedData<T> distinct([bool Function(T previous, T next)? equals]) {
    return LazxDerivedData<T>(
      initialValue: value,
      // Skip the BehaviorSubject replay — the initial value is already
      // captured via initialValue. Only new pushes are filtered.
      sourceValueStream: stream.skip(1).distinct(equals),
      sourceStateStream: state.skip(1),
    );
  }
}
