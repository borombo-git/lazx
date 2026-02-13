import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';
import 'package:mocktail/mocktail.dart';

class FakeViewModel extends Mock implements LazxViewModel {
  final data = LazxData<int>(1);

  @override
  List<LazxData> get props => [data];
}

class TestScreen extends LazxView<FakeViewModel> {
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

    testWidgets('onResume is called when app comes to foreground',
        (WidgetTester tester) async {
      final viewModel = FakeViewModel();
      await tester.pumpWidget(TestApp(viewModel));

      // Simulate app going to background then back to foreground
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

      verify(() => viewModel.onResume()).called(1);
    });

    testWidgets('onPause is called when app goes to background',
        (WidgetTester tester) async {
      final viewModel = FakeViewModel();
      await tester.pumpWidget(TestApp(viewModel));

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);

      verify(() => viewModel.onPause()).called(1);
    });

    testWidgets('onResume and onPause are called multiple times',
        (WidgetTester tester) async {
      final viewModel = FakeViewModel();
      await tester.pumpWidget(TestApp(viewModel));

      // Simulate multiple background/foreground cycles
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

      verify(() => viewModel.onPause()).called(2);
      verify(() => viewModel.onResume()).called(2);
    });

    testWidgets('Lifecycle hooks are not called after dispose',
        (WidgetTester tester) async {
      final viewModel = FakeViewModel();
      await tester.pumpWidget(TestApp(viewModel));

      // Remove the widget (triggers dispose)
      await tester.pumpWidget(MaterialApp(home: Container()));

      // Simulate lifecycle change after dispose
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

      // Should not have been called since the observer was removed
      verifyNever(() => viewModel.onPause());
      verifyNever(() => viewModel.onResume());
    });
  });
}
