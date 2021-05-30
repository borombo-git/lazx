import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';
import 'package:lazx/src/view_model_provider.dart';

class FakeViewModel extends LazxViewModel {
  @override
  List<LazxData> get props => [];
}

class OtherFakeViewModel extends LazxViewModel {
  @override
  List<LazxData> get props => [];
}

class TestView extends LazxView<FakeViewModel> {
  final Widget child;

  TestView(this.child);

  @override
  FakeViewModel getViewModel() => FakeViewModel();

  @override
  Widget build(BuildContext context, FakeViewModel viewModel) {
    return child;
  }
}

void main() {
  group('ViewModelProvider tests', () {
    testWidgets('Test Provide the right view model',
        (WidgetTester tester) async {
      final _childKey = GlobalKey();

      await tester.pumpWidget(TestView(Container(key: _childKey)));
      final screenContext = _childKey.currentContext;
      final providedViewModel =
          ViewModelProvider.getViewModel<FakeViewModel>(screenContext!);
      expect(providedViewModel, isInstanceOf<FakeViewModel>());
    });

    testWidgets('Test Provide the wrong view model',
        (WidgetTester tester) async {
      final _childKey = GlobalKey();

      await tester.pumpWidget(TestView(Container(key: _childKey)));
      final screenContext = _childKey.currentContext;
      expect(
          () => ViewModelProvider.getViewModel<OtherFakeViewModel>(
              screenContext!),
          throwsException);
    });
  });
}
