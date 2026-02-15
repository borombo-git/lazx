import 'package:lazx/lazx.dart';

class OperatorsDemoViewModel extends LazxViewModel {
  /// Raw search query — updated on every keystroke
  final query = LazxData<String>('');

  /// Debounced query — only updates 300ms after typing stops
  late final debouncedQuery = query.debounced(
    const Duration(milliseconds: 300),
  );

  /// Raw counter — incremented on every tap
  final counter = LazxData<int>(0);

  /// Throttled counter — only updates once per second
  late final throttledCounter = counter.throttled(
    const Duration(seconds: 1),
  );

  /// Status text — distinct filters out consecutive duplicates
  final status = LazxData<String>('idle');
  late final distinctStatus = status.distinct();

  @override
  List<LazxDisposable> get props => [
        query,
        debouncedQuery,
        counter,
        throttledCounter,
        status,
        distinctStatus,
      ];

  void updateQuery(String value) {
    query.push(value);
  }

  void increment() {
    counter.push(counter.value + 1);
  }

  void toggleStatus() {
    final next = status.value == 'idle' ? 'active' : 'idle';
    status.push(next);
  }

  void pushSameStatus() {
    status.push(status.value);
  }
}
