import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';
import 'package:mocktail/mocktail.dart';

class FakeEmptyManager extends LazxManager {
  @override
  List<LazxObserver> get props => [];
}

class MockedData<T> extends Mock implements LazxObserver {
  MockedData(T i);
}

class FakeManager extends LazxManager {
  final data = LazxObserver<int>(initialValue: 1);

  @override
  List<LazxObserver> get props => [data];
}

class FakeMockedManager extends LazxManager {
  final data = MockedData<int>(1);

  @override
  List<LazxObserver> get props => [data];
}

void main() {
  group('LazxManager Tests', () {
    group('Empty LazxManager Tests', () {
      test('Init', () {
        final manager = FakeEmptyManager();
        expect(manager.props.length, 0);
      });
    });

    group('LazxManager Tests', () {
      test('Init', () {
        final manager = FakeManager();
        expect(manager.props.length, 1);
        expect(manager.props[0].value, 1);
        manager.props[0].observer.listen(
          expectAsync1(
            (value) {
              expect(value, 1);
            },
          ),
        );
      });

      test('Dispose calls dispose on data', () {
        final manager = FakeMockedManager()..dispose();
        verify(() => manager.props[0].dispose()).called(1);
      });

      test('Dispose stop data\'s streams', () {
        final manager = FakeManager()..dispose();
        expectLater(
            manager.props[0].observer, emitsInOrder([emits(1), emitsDone]));
      });
    });
  });
}
