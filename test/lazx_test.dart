import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

void main() {
  group('LazxData Tests', () {
    group('Simple Lazx Data', () {
      test('Test the right initial value', () {
        final data = LazxData<int>(1);
        expect(data.value, 1);
      });

      test('Test the right value after update', () {
        final data = LazxData<int>(1);
        data.push(2);
        expect(data.value, 2);
      });

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
    });
  });
}
