import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

void main() {
  group('LazxComputed', () {
    group('Initial value', () {
      test('computes initial value from sources', () {
        final a = LazxData<int>(2);
        final b = LazxData<int>(3);
        final computed = LazxComputed<int>(
          sources: [a, b],
          compute: () => a.value + b.value,
        );

        expect(computed.value, 5);
      });

      test('initial state aggregated from sources (all Initial)', () async {
        final a = LazxData<int>(1);
        final b = LazxData<int>(2);
        final computed = LazxComputed<int>(
          sources: [a, b],
          compute: () => a.value + b.value,
        );

        final states = <LxState>[];
        computed.state.listen((s) => states.add(s));
        await Future.delayed(const Duration(milliseconds: 10));

        expect(states.last, LxState.Initial);
      });
    });

    group('Recomputation', () {
      test('updates when source A changes', () async {
        final a = LazxData<int>(1);
        final b = LazxData<int>(10);
        final computed = LazxComputed<int>(
          sources: [a, b],
          compute: () => a.value + b.value,
        );

        expect(computed.value, 11);

        a.push(5);
        await Future.delayed(const Duration(milliseconds: 10));

        expect(computed.value, 15);
      });

      test('updates when source B changes', () async {
        final a = LazxData<int>(1);
        final b = LazxData<int>(10);
        final computed = LazxComputed<int>(
          sources: [a, b],
          compute: () => a.value + b.value,
        );

        b.push(20);
        await Future.delayed(const Duration(milliseconds: 10));

        expect(computed.value, 21);
      });

      test('emits on stream after recomputation', () async {
        final a = LazxData<String>('Hello');
        final b = LazxData<String>('World');
        final computed = LazxComputed<String>(
          sources: [a, b],
          compute: () => '${a.value} ${b.value}',
        );

        final emitted = <String>[];
        computed.stream.skip(1).listen((v) => emitted.add(v));

        a.push('Hi');
        await Future.delayed(const Duration(milliseconds: 10));

        expect(emitted, ['Hi World']);
      });

      test('handles multiple rapid changes', () async {
        final a = LazxData<int>(0);
        final b = LazxData<int>(0);
        final computed = LazxComputed<int>(
          sources: [a, b],
          compute: () => a.value * b.value,
        );

        a.push(2);
        b.push(3);
        a.push(4);
        b.push(5);
        await Future.delayed(const Duration(milliseconds: 10));

        expect(computed.value, 20); // 4 * 5
      });
    });

    group('Distinct behavior', () {
      test('skips emission when computed value unchanged (distinct=true)',
          () async {
        final a = LazxData<int>(5);
        final computed = LazxComputed<int>(
          sources: [a],
          compute: () => a.value ~/ 2, // 5~/2 = 2
          distinct: true,
        );

        expect(computed.value, 2);

        final emitted = <int>[];
        computed.stream.skip(1).listen((v) => emitted.add(v));

        // 4~/2 = 2, same as current -> skipped by distinct
        a.push(4);
        // 6~/2 = 3, different -> emitted
        a.push(6);
        // 7~/2 = 3, same as current -> skipped by distinct
        a.push(7);
        await Future.delayed(const Duration(milliseconds: 10));

        // Only 3 should be emitted (the two pushes that result in 2 and 3
        // are deduplicated)
        expect(emitted, [3]);
      });

      test('emits duplicate values when distinct=false', () async {
        final a = LazxData<int>(5);
        final computed = LazxComputed<int>(
          sources: [a],
          compute: () => a.value ~/ 2, // integer division: 5~/2 = 2
          distinct: false,
        );

        final emitted = <int>[];
        computed.stream.skip(1).listen((v) => emitted.add(v));

        a.push(4); // 4~/2 = 2 — same result
        a.push(5); // 5~/2 = 2 — same result again
        await Future.delayed(const Duration(milliseconds: 10));

        // With distinct=false, both emissions go through even though value is same
        expect(emitted.length, 2);
        expect(emitted, [2, 2]);
      });

      test('distinct=true skips truly unchanged value', () async {
        final a = LazxData<int>(5);
        final computed = LazxComputed<int>(
          sources: [a],
          compute: () => a.value ~/ 2,
          distinct: true,
        );

        final emitted = <int>[];
        computed.stream.skip(1).listen((v) => emitted.add(v));

        a.push(4); // 4~/2 = 2, same as initial (5~/2=2) -> skipped
        a.push(5); // 5~/2 = 2, same -> skipped
        await Future.delayed(const Duration(milliseconds: 10));

        expect(emitted, isEmpty);
      });
    });

    group('State aggregation', () {
      test('Error takes priority over all', () async {
        final a = LazxData<int>(1);
        final b = LazxData<int>(2);
        final computed = LazxComputed<int>(
          sources: [a, b],
          compute: () => a.value + b.value,
        );

        a.setState(LxState.Success);
        b.setState(LxState.Error);
        await Future.delayed(const Duration(milliseconds: 10));

        final states = <LxState>[];
        computed.state.listen((s) => states.add(s));
        await Future.delayed(const Duration(milliseconds: 10));

        expect(states.last, LxState.Error);
      });

      test('Loading takes priority over Success', () async {
        final a = LazxData<int>(1);
        final b = LazxData<int>(2);
        final computed = LazxComputed<int>(
          sources: [a, b],
          compute: () => a.value + b.value,
        );

        a.setState(LxState.Success);
        b.setState(LxState.Loading);
        await Future.delayed(const Duration(milliseconds: 10));

        final states = <LxState>[];
        computed.state.listen((s) => states.add(s));
        await Future.delayed(const Duration(milliseconds: 10));

        expect(states.last, LxState.Loading);
      });

      test('all Success yields Success', () async {
        final a = LazxData<int>(1);
        final b = LazxData<int>(2);
        final computed = LazxComputed<int>(
          sources: [a, b],
          compute: () => a.value + b.value,
        );

        a.setState(LxState.Success);
        b.setState(LxState.Success);
        await Future.delayed(const Duration(milliseconds: 10));

        final states = <LxState>[];
        computed.state.listen((s) => states.add(s));
        await Future.delayed(const Duration(milliseconds: 10));

        expect(states.last, LxState.Success);
      });

      test('Error > Loading priority', () async {
        final a = LazxData<int>(1);
        final b = LazxData<int>(2);
        final computed = LazxComputed<int>(
          sources: [a, b],
          compute: () => a.value + b.value,
        );

        a.setState(LxState.Loading);
        b.setState(LxState.Error);
        await Future.delayed(const Duration(milliseconds: 10));

        final states = <LxState>[];
        computed.state.listen((s) => states.add(s));
        await Future.delayed(const Duration(milliseconds: 10));

        expect(states.last, LxState.Error);
      });

      test('LazxObserver sources are ignored in state aggregation', () async {
        final a = LazxData<int>(1);
        final b = LazxObserver<int>(initialValue: 2);
        final computed = LazxComputed<int>(
          sources: [a, b],
          compute: () => a.value + (b.value ?? 0),
        );

        a.setState(LxState.Success);
        await Future.delayed(const Duration(milliseconds: 10));

        final states = <LxState>[];
        computed.state.listen((s) => states.add(s));
        await Future.delayed(const Duration(milliseconds: 10));

        // Only LazxData contributes to state — observer has no state
        expect(states.last, LxState.Success);
      });
    });

    group('Read-only guards', () {
      test('push throws UnsupportedError', () {
        final a = LazxData<int>(1);
        final computed = LazxComputed<int>(
          sources: [a],
          compute: () => a.value * 2,
        );

        expect(
          () => computed.push(99),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('setState throws UnsupportedError', () {
        final a = LazxData<int>(1);
        final computed = LazxComputed<int>(
          sources: [a],
          compute: () => a.value * 2,
        );

        expect(
          () => computed.setState(LxState.Loading),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('reset throws UnsupportedError', () {
        final a = LazxData<int>(1);
        final computed = LazxComputed<int>(
          sources: [a],
          compute: () => a.value * 2,
        );

        expect(
          () => computed.reset(),
          throwsA(isA<UnsupportedError>()),
        );
      });
    });

    group('Disposal', () {
      test('disposes without error', () {
        final a = LazxData<int>(1);
        final computed = LazxComputed<int>(
          sources: [a],
          compute: () => a.value,
        );

        expect(() => computed.dispose(), returnsNormally);
      });

      test('source updates after disposal do not throw', () {
        final a = LazxData<int>(1);
        final computed = LazxComputed<int>(
          sources: [a],
          compute: () => a.value,
        );
        computed.dispose();

        expect(() => a.push(2), returnsNormally);
      });

      test('works in props list for auto-disposal', () {
        final a = LazxData<int>(1);
        final b = LazxData<int>(2);
        final computed = LazxComputed<int>(
          sources: [a, b],
          compute: () => a.value + b.value,
        );

        final props = <LazxDisposable>[a, b, computed];
        expect(() => props.forEach((p) => p.dispose()), returnsNormally);
      });
    });

    group('Heterogeneous sources', () {
      test('LazxData + LazxObserver sources', () async {
        final data = LazxData<int>(10);
        final observer = LazxObserver<int>(initialValue: 5);
        final computed = LazxComputed<int>(
          sources: [data, observer],
          compute: () => data.value + (observer.value ?? 0),
        );

        expect(computed.value, 15);

        observer.push(20);
        await Future.delayed(const Duration(milliseconds: 10));

        expect(computed.value, 30);
      });

      test('LazxState source triggers state aggregation only', () async {
        final data = LazxData<int>(1);
        final state = LazxState();
        final computed = LazxComputed<int>(
          sources: [data, state],
          compute: () => data.value * 3,
        );

        expect(computed.value, 3);

        state.setState(LxState.Loading);
        await Future.delayed(const Duration(milliseconds: 10));

        // Value shouldn't change — LazxState has no value stream
        expect(computed.value, 3);

        // But the aggregated state should reflect Loading
        final states = <LxState>[];
        computed.state.listen((s) => states.add(s));
        await Future.delayed(const Duration(milliseconds: 10));

        expect(states.last, LxState.Loading);
      });

      test('mixed LazxData + LazxObserver + LazxState', () async {
        final data = LazxData<String>('hello');
        final observer = LazxObserver<String>(initialValue: 'world');
        final state = LazxState();

        final computed = LazxComputed<String>(
          sources: [data, observer, state],
          compute: () => '${data.value} ${observer.value}',
        );

        expect(computed.value, 'hello world');

        data.push('hi');
        await Future.delayed(const Duration(milliseconds: 10));
        expect(computed.value, 'hi world');

        observer.push('dart');
        await Future.delayed(const Duration(milliseconds: 10));
        expect(computed.value, 'hi dart');
      });
    });

    group('Widget integration', () {
      testWidgets('works with LazxBuilder', (tester) async {
        final a = LazxData<int>(3);
        final b = LazxData<int>(4);
        final computed = LazxComputed<int>(
          sources: [a, b],
          compute: () => a.value + b.value,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LazxBuilder<int>(
                data: computed,
                builder: (context, value) => Text('$value'),
              ),
            ),
          ),
        );

        expect(find.text('7'), findsOneWidget);

        a.push(10);
        await tester.pump();

        expect(find.text('14'), findsOneWidget);
      });
    });
  });
}
