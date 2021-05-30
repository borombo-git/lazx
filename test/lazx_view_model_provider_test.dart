import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

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

class FakeStatelessWidget extends StatelessWidget {
  FakeStatelessWidget(Key key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FakeStateFulWidget extends StatefulWidget with LxViewModelProvider {
  FakeStateFulWidget(Key key) : super(key: key);

  @override
  _FakeStateFulWidgetState createState() => _FakeStateFulWidgetState();
}

class _FakeStateFulWidgetState extends State<FakeStateFulWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void main() {
  group('Lazx ViewModel Providers tests', () {
    group('Test Mixin Widget ViewModelProvider', () {
      testWidgets('Test Stateful widget get the right view model',
          (WidgetTester tester) async {
        final _childKey = GlobalKey();

        final statefulWidget = FakeStateFulWidget(_childKey);
        await tester.pumpWidget(TestView(statefulWidget));

        final widgetViewModel =
            statefulWidget.viewModel<FakeViewModel>(_childKey.currentContext!);

        expect(widgetViewModel, isInstanceOf<FakeViewModel>());
      });

      testWidgets('Test Stateull widget get the wrong view model',
          (WidgetTester tester) async {
        final _childKey = GlobalKey();

        final statefulWidget = FakeStateFulWidget(_childKey);
        await tester.pumpWidget(TestView(statefulWidget));

        expect(
            () => statefulWidget
                .viewModel<OtherFakeViewModel>(_childKey.currentContext!),
            throwsException);
      });
    });

    group('Test Stateless Widget ViewModelProvider', () {
      testWidgets('Test Stateless widget get the right view model',
          (WidgetTester tester) async {
        final _childKey = GlobalKey();

        final statelessWidget = FakeStatelessWidget(_childKey);
        await tester.pumpWidget(TestView(statelessWidget));

        final widgetViewModel =
            statelessWidget.viewModel<FakeViewModel>(_childKey.currentContext!);

        expect(widgetViewModel, isInstanceOf<FakeViewModel>());
      });

      testWidgets('Test Stateless widget get the wrong view model',
          (WidgetTester tester) async {
        final _childKey = GlobalKey();

        final statelessWidget = FakeStatelessWidget(_childKey);
        await tester.pumpWidget(TestView(statelessWidget));

        expect(
            () => statelessWidget
                .viewModel<OtherFakeViewModel>(_childKey.currentContext!),
            throwsException);
      });
    });

    group('Test State ViewModelProvider', () {
      testWidgets('Test Stateful widget get the right view model',
          (WidgetTester tester) async {
        final _childKey = GlobalKey();

        final statefulWidget = FakeStateFulWidget(_childKey);
        await tester.pumpWidget(TestView(statefulWidget));

        final widgetViewModel = statefulWidget
            .createState()
            .viewModel<FakeViewModel>(_childKey.currentContext!);

        expect(widgetViewModel, isInstanceOf<FakeViewModel>());
      });

      testWidgets('Test Stateull widget get the wrong view model',
          (WidgetTester tester) async {
        final _childKey = GlobalKey();

        final statefulWidget = FakeStateFulWidget(_childKey);
        await tester.pumpWidget(TestView(statefulWidget));

        expect(
            () => statefulWidget
                .createState()
                .viewModel<OtherFakeViewModel>(_childKey.currentContext!),
            throwsException);
      });
    });
  });
}
