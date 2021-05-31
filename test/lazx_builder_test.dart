import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

class FakeViewModel extends LazxViewModel {
  final data = LazxData<int>(0);

  @override
  List<LazxData> get props => [data];
}

void main() {
  group('LazxBuilder tests', () {
    testWidgets('Init', (WidgetTester tester) async {
      final viewModel = FakeViewModel();
      var numBuilds = 0;

      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: LazxBuilder<int>(
          data: viewModel.data,
          builder: (context, value) {
            numBuilds++;
            print(value);
            return Text('$value');
          },
        ),
      ));

      expect(numBuilds, 1);
      expect(find.text('0'), findsOneWidget);

      viewModel.data.push(1);

      await tester.pumpAndSettle();

      expect(numBuilds, 2);
      expect(find.text('1'), findsOneWidget);
    });
  });
}
