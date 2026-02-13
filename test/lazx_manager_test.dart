import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';
import 'package:mocktail/mocktail.dart';

class FakeEmptyManager extends LazxManager {
  @override
  List<LazxDisposable> get props => [];
}

class MockedData<T> extends Mock implements LazxObserver {
  MockedData(T i);
}

class FakeManager extends LazxManager {
  final data = LazxObserver<int>(initialValue: 1);

  @override
  List<LazxDisposable> get props => [data];
}

class FakeMockedManager extends LazxManager {
  final data = MockedData<int>(1);

  @override
  List<LazxDisposable> get props => [data];
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
        expect(manager.data.value, 1);
        manager.data.stream.listen(
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
            manager.data.stream, emitsInOrder([emits(1), emitsDone]));
      });
    });
  });
}
