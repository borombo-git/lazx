import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

void main() {
  group('Lazx Observer Tests', () {
    group('Values', () {
      test('Test the right initial value', () {
        final data = LazxObserver<int>(initialValue: 1);
        expect(data.value, 1);
      });

      test('Test the right value after update', () {
        final data = LazxObserver<int>(initialValue: 1);
        data.set(2);
        expect(data.value, 2);
      });

      test('Test the right value emitted', () {
        final data = LazxObserver<int>(initialValue: 1);
        data.observer.listen(
          expectAsync1(
            (value) {
              expect(value, 1);
            },
          ),
        );
      });

      test('Test the right value emitted after emitted', () {
        final data = LazxObserver<int>(initialValue: 1);
        data.set(2);
        data.observer.listen(
          expectAsync1(
            (value) {
              expect(value, 2);
            },
          ),
        );
      });
    });
  });
}
