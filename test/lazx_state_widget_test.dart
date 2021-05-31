import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

class SimpleTestWidget extends LazxStateWidget<int> {
  @override
  Widget initial(BuildContext context, data) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text('$data'),
    );
  }
}

class MultipleStateTestWidget extends LazxStateWidget<String> {
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
  group('LazxStateWidget tests', () {
    testWidgets('Test inital builder is called', (WidgetTester tester) async {
      final widget = SimpleTestWidget();
      await tester.pumpWidget(
        Builder(builder: (context) {
          return widget.initial(context, 0);
        }),
      );

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('Test inital builder is called by default',
        (WidgetTester tester) async {
      final widget = SimpleTestWidget();
      await tester.pumpWidget(
        Builder(builder: (context) {
          return widget.loading(context, 0);
        }),
      );
      expect(find.text('0'), findsOneWidget);

      await tester.pumpWidget(
        Builder(builder: (context) {
          return widget.success(context, 0);
        }),
      );
      expect(find.text('0'), findsOneWidget);

      await tester.pumpWidget(
        Builder(builder: (context) {
          return widget.error(context, 0);
        }),
      );
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('Test loading builder is called', (WidgetTester tester) async {
      final widget = MultipleStateTestWidget();
      await tester.pumpWidget(
        Builder(builder: (context) {
          return widget.initial(context, 'Data');
        }),
      );

      expect(find.text('Data'), findsOneWidget);

      await tester.pumpWidget(
        Builder(builder: (context) {
          return widget.loading(context, 'Data');
        }),
      );

      expect(find.text('Data'), findsNothing);
      expect(find.text('Loading'), findsOneWidget);
    });

    testWidgets('Test error builder is called', (WidgetTester tester) async {
      final widget = MultipleStateTestWidget();
      await tester.pumpWidget(
        Builder(builder: (context) {
          return widget.initial(context, 'Data');
        }),
      );

      expect(find.text('Data'), findsOneWidget);

      await tester.pumpWidget(
        Builder(builder: (context) {
          return widget.error(context, 'Data');
        }),
      );

      expect(find.text('Data'), findsNothing);
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('Test success builder is called', (WidgetTester tester) async {
      final widget = MultipleStateTestWidget();
      await tester.pumpWidget(
        Builder(builder: (context) {
          return widget.initial(context, 'Data');
        }),
      );

      expect(find.text('Data'), findsOneWidget);

      await tester.pumpWidget(
        Builder(builder: (context) {
          return widget.success(context, 'Data');
        }),
      );

      expect(find.text('Data'), findsNothing);
      expect(find.text('Success'), findsOneWidget);
    });
  });
}
