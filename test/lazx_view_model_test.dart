import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

class FakeEmptyViewModel extends LazxViewModel {
  @override
  List<LazxData> get props => [];
}

class FakeViewModel extends LazxViewModel {
  final data = LazxData<int>(1);

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
    });
  });
}
