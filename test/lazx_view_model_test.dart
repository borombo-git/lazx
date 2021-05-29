import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';
import 'package:mocktail/mocktail.dart';

class FakeEmptyViewModel extends LazxViewModel {
  @override
  List<LazxData> get props => [];
}

class MockedData<T> extends Mock implements LazxData<T> {
  MockedData(T i);
}

class FakeViewModel extends LazxViewModel {
  final data = LazxData<int>(1);

  @override
  List<LazxData> get props => [data];
}

class FakeMockedViewModel extends LazxViewModel {
  final data = MockedData<int>(1);

  @override
  List<LazxData> get props => [data];
}

void main() {
  group('LazxViewModel Tests', () {
    group('Empty LazxViewModel Tests', () {
      test('Init', () {
        final viewModel = FakeEmptyViewModel();
        expect(viewModel.props.length, 0);
      });
    });

    group('LazxViewModel Tests', () {
      test('Init', () {
        final viewModel = FakeViewModel();
        expect(viewModel.props.length, 1);
        expect(viewModel.props[0].value, 1);
        viewModel.props[0].stream.listen(
          expectAsync1(
            (value) {
              expect(value, 1);
            },
          ),
        );
        viewModel.props[0].state.listen(
          expectAsync1(
            (state) {
              expect(state, LxState.Initial);
            },
          ),
        );
      });

      test('Dispose calls dispose on data', () {
        final viewModel = FakeMockedViewModel()..dispose();
        verify(() => viewModel.props[0].dispose()).called(1);
      });

      test('Dispose stop data\'s streams', () {
        final viewModel = FakeViewModel()..dispose();
        expectLater(
            viewModel.props[0].stream, emitsInOrder([emits(1), emitsDone]));
        expectLater(viewModel.props[0].state,
            emitsInOrder([emits(LxState.Initial), emitsDone]));
      });
    });
  });
}
