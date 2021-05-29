import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';
import 'package:mocktail/mocktail.dart';

class FakeViewModel extends Mock implements LazxViewModel {
  final data = LazxData<int>(1);

  @override
  List<LazxData> get props => [data];
}

class TestScreen extends LazxScreen<FakeViewModel> {
  final FakeViewModel _viewModel;

  TestScreen(this._viewModel);

  @override
  FakeViewModel getViewModel() => _viewModel;

  @override
  Widget build(BuildContext context, FakeViewModel viewModel) {
    return Container();
  }
}

class TestApp extends StatelessWidget {
  final FakeViewModel viewModel;

  const TestApp(this.viewModel) : super();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestScreen(viewModel),
    );
  }
}

void main() {
  group('LazxScreen tests', () {
    testWidgets('Init', (WidgetTester tester) async {
      final viewModel = FakeViewModel();
      await tester.pumpWidget(TestApp(viewModel));

      final testScreen = tester.widget<TestScreen>(
        find.byType(TestScreen),
      );
      verify(() => viewModel.init()).called(1);
      expect(testScreen._viewModel, isInstanceOf<FakeViewModel>());
    });
  });
}
