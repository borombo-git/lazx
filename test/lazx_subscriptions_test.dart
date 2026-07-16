import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

class FakeManager extends LazxManager {
  final counter = LazxObserver<int>(initialValue: 0);

  @override
  List<LazxDisposable> get props => [counter];
}

class ListeningViewModel extends LazxViewModel {
  ListeningViewModel(this.manager);

  final FakeManager manager;
  final received = <int>[];

  @override
  List<LazxDisposable> get props => [];

  @override
  void init() {
    listenTo(manager.counter.stream, received.add);
  }
}

class ListeningManager extends LazxManager {
  final source = LazxObserver<int>();
  final received = <int>[];

  @override
  List<LazxDisposable> get props => [source];

  void startListening() {
    listenTo(source.stream, received.add);
  }
}

void main() {
  group('LazxSubscriptions Tests', () {
    test('listenTo receives pushed values', () async {
      final manager = FakeManager();
      final viewModel = ListeningViewModel(manager)..init();

      manager.counter.push(1);
      manager.counter.push(2);
      await Future<void>.delayed(Duration.zero);

      // BehaviorSubject replays the initial value (0) to new listeners.
      expect(viewModel.received, [0, 1, 2]);
    });

    test('ViewModel dispose cancels listenTo subscriptions', () async {
      final manager = FakeManager();
      final viewModel = ListeningViewModel(manager)..init();

      manager.counter.push(1);
      await Future<void>.delayed(Duration.zero);
      viewModel.dispose();

      manager.counter.push(2);
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.received, [0, 1]);
      expect(viewModel.isDisposed, true);
    });

    test('Manager dispose cancels listenTo subscriptions', () async {
      final listener = ListeningManager()..startListening();

      listener.source.push(1);
      await Future<void>.delayed(Duration.zero);
      listener.dispose();

      expect(listener.received, [1]);
    });

    test('returned subscription can be cancelled early', () async {
      final manager = FakeManager();
      final received = <int>[];
      final viewModel = ListeningViewModel(manager);

      final subscription =
          viewModel.listenTo(manager.counter.stream, received.add);
      await Future<void>.delayed(Duration.zero);
      await subscription.cancel();

      manager.counter.push(1);
      await Future<void>.delayed(Duration.zero);

      expect(received, [0]);
      // dispose after an early cancel must not throw
      viewModel.dispose();
    });

    test('cancelSubscriptions is safe to call twice', () {
      final manager = FakeManager();
      final viewModel = ListeningViewModel(manager)..init();

      viewModel.cancelSubscriptions();
      expect(viewModel.cancelSubscriptions, returnsNormally);
    });

    test('dispose still disposes props after cancelling subscriptions', () {
      final manager = FakeManager();
      final viewModel = ListeningViewModel(manager)..init();
      viewModel.dispose();

      manager.dispose();
      expectLater(manager.counter.stream, emitsThrough(emitsDone));
    });
  });
}
