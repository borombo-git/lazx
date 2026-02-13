import '../lazx.dart';

/// [LazxExecutor] is a mixin for [LazxViewModel] that provides automatic
/// loading and error state management for async operations.
///
/// It exposes [isLoading] and [error] as reactive [LazxData] fields, and an
/// [execute] method that wraps any async task with try/catch and
/// loading/error transitions.
///
/// Usage:
/// ```dart
/// class MyViewModel extends LazxViewModel with LazxExecutor {
///   final items = LazxData<List<Item>>([]);
///
///   @override
///   List<LazxDisposable> get props => [items, ...executorProps];
///
///   Future<void> loadItems() async {
///     final result = await execute(() => api.fetchItems());
///     if (result != null) {
///       items.push(result, lxState: LxState.Success);
///     }
///   }
/// }
/// ```
mixin LazxExecutor on LazxViewModel {
  /// Reactive loading state — `true` while an [execute] call is in progress
  final LazxData<bool> isLoading = LazxData(false);

  /// Reactive error state — holds the caught error, or `null` when clear
  final LazxData<Object?> error = LazxData(null);

  /// Convenience getter for the executor's reactive properties.
  /// Add these to your [props] list: `[...executorProps]`
  List<LazxDisposable> get executorProps => [isLoading, error];

  /// Executes an async [task] with automatic loading and error management.
  ///
  /// - Sets [isLoading] to `true` before the task (unless [silent] is `true`)
  /// - Clears [error] before the task
  /// - On success, returns the result
  /// - On failure, captures the error in [error] and returns `null`
  /// - Sets [isLoading] back to `false` after the task (unless [silent])
  /// - Does nothing if the ViewModel has been disposed
  ///
  /// Use [silent] for background refreshes where you don't want a loading
  /// indicator.
  Future<T?> execute<T>(
    Future<T> Function() task, {
    bool silent = false,
  }) async {
    if (isDisposed) return null;
    if (!silent) isLoading.push(true);
    error.push(null);
    try {
      final result = await task();
      return result;
    } catch (e) {
      if (!isDisposed) error.push(e);
      return null;
    } finally {
      if (!isDisposed && !silent) isLoading.push(false);
    }
  }

  /// Clears the current error
  void clearError() => error.push(null);
}
