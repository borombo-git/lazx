import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

class FakeViewModel extends LazxViewModel {
  final data = LazxData<int>(0);

  @override
  List<LazxData> get props => [data];
}

class SimpleTestWidget extends LazxStateWidget<int> {
  @override
  Widget initial(BuildContext context, data) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text('$data'),
    );
  }
}

class MultipleStateTestWidget extends LazxStateWidget<int> {
  @override
  Widget initial(BuildContext context, data) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text('$data'),
    );
  }

  Widget loading(BuildContext context, data) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text('Loading'),
    );
  }

  Widget error(BuildContext context, data) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text('Error'),
    );
  }

  Widget success(BuildContext context, data) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text('Success'),
    );
  }
}

void main() {
  group('LazxDataBuilder tests', () {
    testWidgets('Test inital builder is called by default',
        (WidgetTester tester) async {
      final viewModel = FakeViewModel();

      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: LazxDataBuilder(
          data: viewModel.data,
          lxWidget: SimpleTestWidget(),
        ),
      ));

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('Test inital builder is called when data is updated',
        (WidgetTester tester) async {
      final viewModel = FakeViewModel();

      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: LazxDataBuilder(
          data: viewModel.data,
          lxWidget: SimpleTestWidget(),
        ),
      ));

      expect(find.text('0'), findsOneWidget);

      viewModel.data.push(1);
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets(
        'Test inital builder is called when other state are not specified',
        (WidgetTester tester) async {
      final viewModel = FakeViewModel();

      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: LazxDataBuilder(
          data: viewModel.data,
          lxWidget: SimpleTestWidget(),
        ),
      ));

      expect(find.text('0'), findsOneWidget);

      viewModel.data.setState(LxState.Loading);
      await tester.pumpAndSettle();

      expect(find.text('Loading'), findsNothing);
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('Test other builder is called with according state',
        (WidgetTester tester) async {
      final viewModel = FakeViewModel();

      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: LazxDataBuilder(
          data: viewModel.data,
          lxWidget: MultipleStateTestWidget(),
        ),
      ));

      expect(find.text('0'), findsOneWidget);

      viewModel.data.setState(LxState.Loading);
      await tester.pumpAndSettle();

      expect(find.text('0'), findsNothing);
      expect(find.text('Loading'), findsOneWidget);

      viewModel.data.push(1, lxState: LxState.Success);
      await tester.pumpAndSettle();

      expect(find.text('1'), findsNothing);
      expect(find.text('Success'), findsOneWidget);

      viewModel.data.push(1, lxState: LxState.Error);
      await tester.pumpAndSettle();

      expect(find.text('1'), findsNothing);
      expect(find.text('Error'), findsOneWidget);
    });
  });
}
