import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

class FakeViewModel extends LazxViewModel {
  final data = LazxData<int>(0);

  @override
  List<LazxData> get props => [data];
}

class TestWidget extends LazxWidget {
  final LazxData data;

  TestWidget(this.data) : super(data: data);

  @override
  Widget build(BuildContext context, LxState state, data) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          Text('$data'),
          Text('${state.toString()}'),
        ],
      ),
    );
  }
}

void main() {
  group('LazxWidget tests', () {
    testWidgets('Test initial value and state', (WidgetTester tester) async {
      final viewModel = FakeViewModel();

      await tester.pumpWidget(TestWidget(viewModel.data));

      expect(find.text('0'), findsOneWidget);
      expect(find.text('LxState.Initial'), findsOneWidget);
    });

    testWidgets('Test edited value and state', (WidgetTester tester) async {
      final viewModel = FakeViewModel();

      await tester.pumpWidget(TestWidget(viewModel.data));

      expect(find.text('0'), findsOneWidget);
      expect(find.text('LxState.Initial'), findsOneWidget);

      viewModel.data.setState(LxState.Loading);

      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);
      expect(find.text('LxState.Loading'), findsOneWidget);

      viewModel.data.push(1, lxState: LxState.Success);

      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('LxState.Success'), findsOneWidget);

      viewModel.data.push(-1, lxState: LxState.Error);

      await tester.pumpAndSettle();

      expect(find.text('-1'), findsOneWidget);
      expect(find.text('LxState.Error'), findsOneWidget);

      viewModel.data.push(-2);

      await tester.pumpAndSettle();

      expect(find.text('-2'), findsOneWidget);
      expect(find.text('LxState.Error'), findsOneWidget);
    });
  });
}
