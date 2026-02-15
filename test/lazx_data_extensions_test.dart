import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

void main() {
  group('LazxData Stream Operators', () {
    group('debounced()', () {
      test('initial value is available immediately', () {
        final source = LazxData<String>('hello');
        final debounced = source.debounced(const Duration(milliseconds: 100));

        expect(debounced.value, 'hello');
      });

      test('emits only after duration with no new values', () async {
        final source = LazxData<String>('');
        final debounced = source.debounced(const Duration(milliseconds: 50));

        final emitted = <String>[];
        debounced.stream.skip(1).listen((v) => emitted.add(v));

        source.push('a');
        source.push('ab');
        source.push('abc');

        // Before debounce window
        await Future.delayed(const Duration(milliseconds: 20));
        expect(emitted, isEmpty);

        // After debounce window
        await Future.delayed(const Duration(milliseconds: 60));
        expect(emitted, ['abc']);
      });

      test('rapid pushes only emit last value', () async {
        final source = LazxData<int>(0);
        final debounced = source.debounced(const Duration(milliseconds: 50));

        final emitted = <int>[];
        debounced.stream.skip(1).listen((v) => emitted.add(v));

        for (var i = 1; i <= 10; i++) {
          source.push(i);
          await Future.delayed(const Duration(milliseconds: 5));
        }

        await Future.delayed(const Duration(milliseconds: 80));
        expect(emitted, [10]);
      });

      test('forwards state changes from source', () async {
        final source = LazxData<int>(0);
        final debounced = source.debounced(const Duration(milliseconds: 50));

        final states = <LxState>[];
        debounced.state.skip(1).listen((s) => states.add(s));

        source.setState(LxState.Loading);

        await Future.delayed(const Duration(milliseconds: 20));
        expect(states, [LxState.Loading]);
      });
    });

    group('throttled()', () {
      test('initial value is available immediately', () {
        final source = LazxData<int>(42);
        final throttled = source.throttled(const Duration(milliseconds: 100));

        expect(throttled.value, 42);
      });

      test('emits first value and ignores subsequent during window', () async {
        final source = LazxData<int>(0);
        final throttled = source.throttled(const Duration(milliseconds: 100));

        final emitted = <int>[];
        // Skip the initial replay from BehaviorSubject
        throttled.stream.skip(1).listen((v) => emitted.add(v));

        source.push(1);
        await Future.delayed(const Duration(milliseconds: 10));
        source.push(2);
        await Future.delayed(const Duration(milliseconds: 10));
        source.push(3);

        // First value should have gone through
        await Future.delayed(const Duration(milliseconds: 20));
        expect(emitted.first, 1);

        // 2 and 3 should be ignored during the throttle window
        expect(emitted.where((v) => v == 2 || v == 3), isEmpty);
      });

      test('emits again after throttle window expires', () async {
        final source = LazxData<int>(0);
        final throttled = source.throttled(const Duration(milliseconds: 50));

        final emitted = <int>[];
        throttled.stream.skip(1).listen((v) => emitted.add(v));

        source.push(1);
        await Future.delayed(const Duration(milliseconds: 80));

        source.push(2);
        await Future.delayed(const Duration(milliseconds: 80));

        expect(emitted, [1, 2]);
      });
    });

    group('distinct()', () {
      test('initial value is available immediately', () {
        final source = LazxData<String>('hello');
        final distinctData = source.distinct();

        expect(distinctData.value, 'hello');
      });

      test('skips consecutive duplicate values', () async {
        final source = LazxData<int>(0);
        final distinctData = source.distinct();

        final emitted = <int>[];
        distinctData.stream.skip(1).listen((v) => emitted.add(v));

        source.push(1);
        source.push(1);
        source.push(2);
        source.push(2);
        source.push(3);

        await Future.delayed(const Duration(milliseconds: 20));
        expect(emitted, [1, 2, 3]);
      });

      test('custom comparator works', () async {
        final source = LazxData<List<int>>([1, 2]);
        final distinctData = source.distinct(
          (a, b) => a.length == b.length,
        );

        final emitted = <List<int>>[];
        distinctData.stream.skip(1).listen((v) => emitted.add(v));

        source.push([3, 4]); // first push, passes through
        source.push([5, 6]); // same length as [3,4] → skipped
        source.push([7, 8, 9]); // different length → emitted
        source.push([10, 11, 12]); // same length as [7,8,9] → skipped

        await Future.delayed(const Duration(milliseconds: 20));
        expect(emitted.length, 2);
        expect(emitted[0], [3, 4]);
        expect(emitted[1], [7, 8, 9]);
      });
    });

    group('Read-only guards', () {
      test('push throws UnsupportedError', () {
        final source = LazxData<int>(0);
        final derived = source.debounced(const Duration(milliseconds: 100));

        expect(
          () => derived.push(1),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('setState throws UnsupportedError', () {
        final source = LazxData<int>(0);
        final derived = source.throttled(const Duration(milliseconds: 100));

        expect(
          () => derived.setState(LxState.Loading),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('reset throws UnsupportedError', () {
        final source = LazxData<int>(0);
        final derived = source.distinct();

        expect(
          () => derived.reset(),
          throwsA(isA<UnsupportedError>()),
        );
      });
    });

    group('Disposal', () {
      test('derived disposes without error', () {
        final source = LazxData<int>(0);
        final derived = source.debounced(const Duration(milliseconds: 100));

        expect(() => derived.dispose(), returnsNormally);
      });

      test('source updates after derived disposal do not throw', () {
        final source = LazxData<int>(0);
        final derived = source.debounced(const Duration(milliseconds: 100));
        derived.dispose();

        // Source should still work
        expect(() => source.push(1), returnsNormally);
      });

      test('works in props list for auto-disposal', () {
        final source = LazxData<int>(0);
        final derived = source.debounced(const Duration(milliseconds: 100));

        final props = <LazxDisposable>[source, derived];
        expect(() => props.forEach((p) => p.dispose()), returnsNormally);
      });
    });

    group('Chaining', () {
      test('debounced().distinct() works', () async {
        final source = LazxData<String>('');
        final chained = source
            .debounced(const Duration(milliseconds: 30))
            .distinct();

        expect(chained.value, '');

        final emitted = <String>[];
        chained.stream.skip(1).listen((v) => emitted.add(v));

        source.push('hello');
        await Future.delayed(const Duration(milliseconds: 60));

        // Push same value again
        source.push('hello');
        await Future.delayed(const Duration(milliseconds: 60));

        // Push different value
        source.push('world');
        await Future.delayed(const Duration(milliseconds: 60));

        // 'hello' should appear once (distinct filters the second), then 'world'
        expect(emitted, ['hello', 'world']);
      });
    });

    group('Widget integration', () {
      testWidgets('works with LazxBuilder', (tester) async {
        final source = LazxData<int>(0);
        final derived = source.distinct();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LazxBuilder<int>(
                data: derived,
                builder: (context, value) => Text('$value'),
              ),
            ),
          ),
        );

        expect(find.text('0'), findsOneWidget);

        source.push(42);
        await tester.pump();

        expect(find.text('42'), findsOneWidget);
      });
    });
  });
}
