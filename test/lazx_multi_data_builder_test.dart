import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

class FakeViewModel extends LazxViewModel {
  final value = LazxData<int>(0);
  final show = LazxData<bool>(false);

  @override
  List<LazxData> get props => [value, show];
}

void main() {
  group('LazxMultiBuilder tests', () {
    testWidgets('Init', (WidgetTester tester) async {
      final viewModel = FakeViewModel();
      var numBuilds = 0;

      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: LazxMultiBuilder(
          data: [
            viewModel.value,
            viewModel.show,
          ],
          builder: (context, values) {
            numBuilds++;
            return Column(
              children: [
                Text('Value ${values[0]}'),
                Text('Show ${values[1]}'),
              ],
            );
          },
        ),
      ));

      expect(numBuilds, 1);
      expect(find.text('Value 0'), findsOneWidget);
      expect(find.text('Show false'), findsOneWidget);

      viewModel.value.push(1);

      await tester.pumpAndSettle();

      expect(numBuilds, 2);
      expect(find.text('Value 1'), findsOneWidget);
      expect(find.text('Show false'), findsOneWidget);

      viewModel.show.push(true);

      await tester.pumpAndSettle();

      expect(numBuilds, 3);
      expect(find.text('Value 1'), findsOneWidget);
      expect(find.text('Show true'), findsOneWidget);
    });
  });
}
