import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

Widget _directionality(Widget child) {
  return Directionality(textDirection: TextDirection.ltr, child: child);
}

void main() {
  group('LazxMultiBuilder2 tests', () {
    testWidgets('Renders initial values with correct types',
        (WidgetTester tester) async {
      final counter = LazxData<int>(0);
      final visible = LazxData<bool>(true);

      await tester.pumpWidget(_directionality(
        LazxMultiBuilder2<int, bool>(
          data1: counter,
          data2: visible,
          builder: (context, count, isVisible) {
            return Text('$count $isVisible');
          },
        ),
      ));

      expect(find.text('0 true'), findsOneWidget);
    });

    testWidgets('Rebuilds when data changes', (WidgetTester tester) async {
      final counter = LazxData<int>(0);
      final label = LazxData<String>('hello');

      await tester.pumpWidget(_directionality(
        LazxMultiBuilder2<int, String>(
          data1: counter,
          data2: label,
          builder: (context, count, text) {
            return Text('$count $text');
          },
        ),
      ));

      expect(find.text('0 hello'), findsOneWidget);

      counter.push(5);
      await tester.pumpAndSettle();
      expect(find.text('5 hello'), findsOneWidget);

      label.push('world');
      await tester.pumpAndSettle();
      expect(find.text('5 world'), findsOneWidget);
    });
  });

  group('LazxMultiBuilder3 tests', () {
    testWidgets('Renders initial values with correct types',
        (WidgetTester tester) async {
      final a = LazxData<int>(1);
      final b = LazxData<String>('two');
      final c = LazxData<bool>(false);

      await tester.pumpWidget(_directionality(
        LazxMultiBuilder3<int, String, bool>(
          data1: a,
          data2: b,
          data3: c,
          builder: (context, v1, v2, v3) {
            return Text('$v1 $v2 $v3');
          },
        ),
      ));

      expect(find.text('1 two false'), findsOneWidget);
    });

    testWidgets('Rebuilds when any data changes', (WidgetTester tester) async {
      final a = LazxData<int>(1);
      final b = LazxData<String>('two');
      final c = LazxData<bool>(false);

      await tester.pumpWidget(_directionality(
        LazxMultiBuilder3<int, String, bool>(
          data1: a,
          data2: b,
          data3: c,
          builder: (context, v1, v2, v3) {
            return Text('$v1 $v2 $v3');
          },
        ),
      ));

      c.push(true);
      await tester.pumpAndSettle();
      expect(find.text('1 two true'), findsOneWidget);
    });
  });

  group('LazxMultiBuilder4 tests', () {
    testWidgets('Renders initial values with correct types',
        (WidgetTester tester) async {
      final a = LazxData<int>(1);
      final b = LazxData<String>('x');
      final c = LazxData<bool>(true);
      final d = LazxData<double>(3.14);

      await tester.pumpWidget(_directionality(
        LazxMultiBuilder4<int, String, bool, double>(
          data1: a,
          data2: b,
          data3: c,
          data4: d,
          builder: (context, v1, v2, v3, v4) {
            return Text('$v1 $v2 $v3 $v4');
          },
        ),
      ));

      expect(find.text('1 x true 3.14'), findsOneWidget);
    });

    testWidgets('Rebuilds when any data changes', (WidgetTester tester) async {
      final a = LazxData<int>(1);
      final b = LazxData<String>('x');
      final c = LazxData<bool>(true);
      final d = LazxData<double>(3.14);

      await tester.pumpWidget(_directionality(
        LazxMultiBuilder4<int, String, bool, double>(
          data1: a,
          data2: b,
          data3: c,
          data4: d,
          builder: (context, v1, v2, v3, v4) {
            return Text('$v1 $v2 $v3 $v4');
          },
        ),
      ));

      d.push(2.71);
      await tester.pumpAndSettle();
      expect(find.text('1 x true 2.71'), findsOneWidget);
    });
  });

  group('LazxMultiBuilder5 tests', () {
    testWidgets('Renders initial values with correct types',
        (WidgetTester tester) async {
      final a = LazxData<int>(1);
      final b = LazxData<String>('y');
      final c = LazxData<bool>(false);
      final d = LazxData<double>(0.5);
      final e = LazxData<List<int>>([1, 2]);

      await tester.pumpWidget(_directionality(
        LazxMultiBuilder5<int, String, bool, double, List<int>>(
          data1: a,
          data2: b,
          data3: c,
          data4: d,
          data5: e,
          builder: (context, v1, v2, v3, v4, v5) {
            return Text('$v1 $v2 $v3 $v4 $v5');
          },
        ),
      ));

      expect(find.text('1 y false 0.5 [1, 2]'), findsOneWidget);
    });

    testWidgets('Rebuilds when any data changes', (WidgetTester tester) async {
      final a = LazxData<int>(1);
      final b = LazxData<String>('y');
      final c = LazxData<bool>(false);
      final d = LazxData<double>(0.5);
      final e = LazxData<List<int>>([1, 2]);

      await tester.pumpWidget(_directionality(
        LazxMultiBuilder5<int, String, bool, double, List<int>>(
          data1: a,
          data2: b,
          data3: c,
          data4: d,
          data5: e,
          builder: (context, v1, v2, v3, v4, v5) {
            return Text('$v1 $v2 $v3 $v4 $v5');
          },
        ),
      ));

      a.push(99);
      e.push([3, 4, 5]);
      await tester.pumpAndSettle();
      expect(find.text('99 y false 0.5 [3, 4, 5]'), findsOneWidget);
    });
  });
}
