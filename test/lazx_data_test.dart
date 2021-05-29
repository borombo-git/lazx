import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

void main() {
  group('LazxData Tests', () {
    group('Values', () {
      test('Test the right initial value', () {
        final data = LazxData<int>(1);
        expect(data.value, 1);
      });

      test('Test the right value after update', () {
        final data = LazxData<int>(1);
        data.push(2);
        expect(data.value, 2);
      });

      test('Test the right value emitted', () {
        final data = LazxData<int>(1);
        data.stream.listen(
          expectAsync1(
            (value) {
              expect(value, 1);
            },
          ),
        );
      });

      test('Test the right value emitted after emitted', () {
        final data = LazxData<int>(1);
        data.push(2);
        data.stream.listen(
          expectAsync1(
            (value) {
              expect(value, 2);
            },
          ),
        );
      });
    });

    group('States', () {
      test('Test the right initial state', () {
        final data = LazxData<int>(1);
        data.state.listen(
          expectAsync1(
            (event) {
              expect(event, LxState.Initial);
            },
          ),
        );
      });

      test('Test the right state after update', () {
        final data = LazxData<int>(1);
        data.setState(LxState.Loading);
        data.state.listen(
          expectAsync1(
            (event) {
              expect(event, LxState.Loading);
            },
          ),
        );
      });
    });

    group('State/Value Update', () {
      test('Test the right state/value after update', () {
        final data = LazxData<int>(1);
        data.push(2, lxState: LxState.Success);
        expect(data.value, 2);
        data.stream.listen(
          expectAsync1(
            (value) {
              expect(value, 2);
            },
          ),
        );
        data.state.listen(
          expectAsync1(
            (event) {
              expect(event, LxState.Success);
            },
          ),
        );
      });

      test('Test the right state/value after update', () {
        final data = LazxData<int>(1);
        data.push(2, lxState: LxState.Success);
        expect(data.value, 2);
        data.stream.listen(
          expectAsync1(
            (value) {
              expect(value, 2);
            },
          ),
        );
        data.state.listen(
          expectAsync1(
            (event) {
              expect(event, LxState.Success);
            },
          ),
        );
      });
    });
  });
}
