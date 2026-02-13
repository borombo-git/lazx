import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

class TestViewModel extends LazxViewModel with LazxExecutor {
  final items = LazxData<List<String>>([]);

  @override
  List<LazxDisposable> get props => [items, ...executorProps];
}

void main() {
  group('LazxExecutor tests', () {
    late TestViewModel viewModel;

    setUp(() {
      viewModel = TestViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('Initial state: isLoading is false, error is null', () {
      expect(viewModel.isLoading.value, false);
      expect(viewModel.error.value, null);
    });

    test('execute sets isLoading to true during task', () async {
      bool wasLoadingDuringTask = false;

      await viewModel.execute(() async {
        wasLoadingDuringTask = viewModel.isLoading.value;
        return 'done';
      });

      expect(wasLoadingDuringTask, true);
      expect(viewModel.isLoading.value, false);
    });

    test('execute returns the result on success', () async {
      final result = await viewModel.execute(() async => 42);

      expect(result, 42);
      expect(viewModel.error.value, null);
    });

    test('execute captures error on failure', () async {
      final result = await viewModel.execute(() async {
        throw Exception('Something went wrong');
      });

      expect(result, null);
      expect(viewModel.error.value, isA<Exception>());
      expect(viewModel.isLoading.value, false);
    });

    test('execute clears previous error before new task', () async {
      // First call fails
      await viewModel.execute(() async {
        throw Exception('First error');
      });
      expect(viewModel.error.value, isNotNull);

      // Second call succeeds — error should be cleared
      await viewModel.execute(() async => 'ok');
      expect(viewModel.error.value, null);
    });

    test('execute with silent does not change isLoading', () async {
      bool wasLoadingDuringTask = false;

      await viewModel.execute(
        () async {
          wasLoadingDuringTask = viewModel.isLoading.value;
          return 'done';
        },
        silent: true,
      );

      expect(wasLoadingDuringTask, false);
      expect(viewModel.isLoading.value, false);
    });

    test('execute with silent still captures errors', () async {
      await viewModel.execute(
        () async => throw Exception('silent error'),
        silent: true,
      );

      expect(viewModel.error.value, isA<Exception>());
    });

    test('execute returns null when disposed', () async {
      viewModel.dispose();

      final result = await viewModel.execute(() async => 42);

      expect(result, null);
    });

    test('execute does not update error after dispose', () async {
      // Start a task that will fail, but dispose before it completes
      viewModel.dispose();

      await viewModel.execute(() async {
        throw Exception('error after dispose');
      });

      // Error should still be null since we were disposed
      expect(viewModel.error.value, null);
    });

    test('clearError resets error to null', () async {
      await viewModel.execute(() async => throw Exception('oops'));
      expect(viewModel.error.value, isNotNull);

      viewModel.clearError();
      expect(viewModel.error.value, null);
    });

    test('isDisposed is tracked on LazxViewModel', () {
      expect(viewModel.isDisposed, false);
      viewModel.dispose();
      expect(viewModel.isDisposed, true);
    });

    test('executorProps contains isLoading and error', () {
      expect(viewModel.executorProps, hasLength(2));
      expect(viewModel.executorProps, contains(viewModel.isLoading));
      expect(viewModel.executorProps, contains(viewModel.error));
    });
  });
}
