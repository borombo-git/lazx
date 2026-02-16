import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';
import 'package:lazx/lazx_testing.dart';

void main() {
  // ------------------------------------------------------------------
  // waitForState
  // ------------------------------------------------------------------
  group('waitForState', () {
    test('resolves immediately when current state already matches', () async {
      final data = LazxData<int>(0);
      // LazxData starts in Initial state
      await data.waitForState(LxState.Initial);
    });

    test('resolves when future state is pushed', () async {
      final data = LazxData<int>(0);

      // Schedule state change after a short delay
      Future.delayed(Duration(milliseconds: 50), () {
        data.setState(LxState.Loading);
      });

      await data.waitForState(LxState.Loading);
    });

    test('throws TimeoutException with descriptive message', () async {
      final data = LazxData<int>(0);

      expect(
        () => data.waitForState(
          LxState.Success,
          timeout: Duration(milliseconds: 100),
        ),
        throwsA(isA<TimeoutException>().having(
          (e) => e.message,
          'message',
          contains('waitForState(LxState.Success)'),
        )),
      );
    });

    test('works with LazxState (state-only container)', () async {
      final lxState = LazxState();
      // LazxState starts in Initial
      await lxState.waitForState(LxState.Initial);

      Future.delayed(Duration(milliseconds: 50), () {
        lxState.setState(LxState.Error);
      });

      await lxState.waitForState(LxState.Error);
    });

    test('works with LazxDerivedData', () async {
      final source = LazxData<int>(0);
      final derived = source.debounced(Duration(milliseconds: 10));

      // Derived starts in Initial (inherited from source)
      await derived.waitForState(LxState.Initial);

      Future.delayed(Duration(milliseconds: 50), () {
        source.push(1, lxState: LxState.Success);
      });

      await derived.waitForState(LxState.Success);

      source.dispose();
      derived.dispose();
    });
  });

  // ------------------------------------------------------------------
  // expectStateSequence
  // ------------------------------------------------------------------
  group('expectStateSequence', () {
    test('completes for a single-element sequence', () async {
      final data = LazxData<int>(0);
      // BehaviorSubject replays Initial immediately
      await data.expectStateSequence([LxState.Initial]);
    });

    test('verifies multi-state transition', () async {
      final data = LazxData<int>(0);

      Future.delayed(Duration(milliseconds: 50), () {
        data.setState(LxState.Loading);
      });
      Future.delayed(Duration(milliseconds: 100), () {
        data.setState(LxState.Success);
      });

      await data.expectStateSequence([
        LxState.Initial,
        LxState.Loading,
        LxState.Success,
      ]);
    });

    test('throws StateError on unexpected state', () async {
      final data = LazxData<int>(0);

      Future.delayed(Duration(milliseconds: 50), () {
        data.setState(LxState.Error);
      });

      expect(
        () => data.expectStateSequence([
          LxState.Initial,
          LxState.Loading, // expected Loading but Error arrives
        ]),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          allOf(
            contains('expected LxState.Loading'),
            contains('got LxState.Error'),
            contains('index 1'),
          ),
        )),
      );
    });

    test('completes immediately for empty sequence', () async {
      final data = LazxData<int>(0);
      await data.expectStateSequence([]);
    });

    test('throws TimeoutException when sequence is incomplete', () async {
      final data = LazxData<int>(0);

      // Only Initial will arrive, but we expect Loading too
      expect(
        () => data.expectStateSequence(
          [LxState.Initial, LxState.Loading],
          timeout: Duration(milliseconds: 100),
        ),
        throwsA(isA<TimeoutException>().having(
          (e) => e.message,
          'message',
          contains('1 of 2'),
        )),
      );
    });
  });

  // ------------------------------------------------------------------
  // waitForValue (LazxData)
  // ------------------------------------------------------------------
  group('waitForValue (LazxData)', () {
    test('resolves immediately when current value matches', () async {
      final data = LazxData<int>(42);
      await data.waitForValue(42);
    });

    test('resolves when future value is pushed', () async {
      final data = LazxData<int>(0);

      Future.delayed(Duration(milliseconds: 50), () {
        data.push(99);
      });

      await data.waitForValue(99);
    });

    test('throws TimeoutException with descriptive message', () async {
      final data = LazxData<int>(0);

      expect(
        () => data.waitForValue(
          999,
          timeout: Duration(milliseconds: 100),
        ),
        throwsA(isA<TimeoutException>().having(
          (e) => e.message,
          'message',
          contains('waitForValue(999)'),
        )),
      );
    });

    test('works with string values', () async {
      final data = LazxData<String>('hello');

      Future.delayed(Duration(milliseconds: 50), () {
        data.push('world');
      });

      await data.waitForValue('world');
    });
  });

  // ------------------------------------------------------------------
  // expectEmits (LazxData)
  // ------------------------------------------------------------------
  group('expectEmits (LazxData)', () {
    test('captures single-element replay', () async {
      final data = LazxData<int>(5);
      // BehaviorSubject replays 5 as first emission
      await data.expectEmits([5]);
    });

    test('captures replay + new pushes', () async {
      final data = LazxData<int>(0);

      Future.delayed(Duration(milliseconds: 50), () {
        data.push(1);
      });
      Future.delayed(Duration(milliseconds: 100), () {
        data.push(2);
      });

      await data.expectEmits([0, 1, 2]);
    });

    test('throws StateError on value mismatch', () async {
      final data = LazxData<int>(0);

      Future.delayed(Duration(milliseconds: 50), () {
        data.push(99); // expected 1 but got 99
      });

      expect(
        () => data.expectEmits([0, 1]),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          allOf(
            contains('mismatch at index 1'),
            contains('expected 1'),
            contains('got 99'),
          ),
        )),
      );
    });

    test('completes immediately for empty list', () async {
      final data = LazxData<int>(0);
      await data.expectEmits([]);
    });

    test('throws TimeoutException when not enough emissions', () async {
      final data = LazxData<int>(0);

      expect(
        () => data.expectEmits(
          [0, 1, 2],
          timeout: Duration(milliseconds: 100),
        ),
        throwsA(isA<TimeoutException>().having(
          (e) => e.message,
          'message',
          contains('1 of 3'),
        )),
      );
    });
  });

  // ------------------------------------------------------------------
  // waitForValue (LazxObserver)
  // ------------------------------------------------------------------
  group('waitForValue (LazxObserver)', () {
    test('resolves immediately when current value matches', () async {
      final obs = LazxObserver<int>(initialValue: 10);
      await obs.waitForValue(10);
    });

    test('resolves when future value is pushed', () async {
      final obs = LazxObserver<int>(initialValue: 0);

      Future.delayed(Duration(milliseconds: 50), () {
        obs.push(42);
      });

      await obs.waitForValue(42);
    });

    test('throws TimeoutException when value never arrives', () async {
      final obs = LazxObserver<int>(initialValue: 0);

      expect(
        () => obs.waitForValue(
          999,
          timeout: Duration(milliseconds: 100),
        ),
        throwsA(isA<TimeoutException>()),
      );
    });
  });

  // ------------------------------------------------------------------
  // expectEmits (LazxObserver)
  // ------------------------------------------------------------------
  group('expectEmits (LazxObserver)', () {
    test('captures replay + new pushes', () async {
      final obs = LazxObserver<String>(initialValue: 'a');

      Future.delayed(Duration(milliseconds: 50), () {
        obs.push('b');
      });
      Future.delayed(Duration(milliseconds: 100), () {
        obs.push('c');
      });

      await obs.expectEmits(['a', 'b', 'c']);
    });

    test('throws StateError on mismatch', () async {
      final obs = LazxObserver<int>(initialValue: 1);

      Future.delayed(Duration(milliseconds: 50), () {
        obs.push(3); // expected 2
      });

      expect(
        () => obs.expectEmits([1, 2]),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('mismatch at index 1'),
        )),
      );
    });
  });

  // ------------------------------------------------------------------
  // Disposal safety
  // ------------------------------------------------------------------
  group('Disposal safety', () {
    test('times out on disposed LazxData', () async {
      final data = LazxData<int>(0);
      data.dispose();

      expect(
        () => data.waitForState(
          LxState.Success,
          timeout: Duration(milliseconds: 100),
        ),
        throwsA(isA<TimeoutException>()),
      );
    });

    test('times out on disposed LazxObserver', () async {
      final obs = LazxObserver<int>(initialValue: 0);
      obs.dispose();

      expect(
        () => obs.waitForValue(
          42,
          timeout: Duration(milliseconds: 100),
        ),
        throwsA(isA<TimeoutException>()),
      );
    });
  });
}
