import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

void main() {
  group('LazxData Tests', () {
    group('Simple Lazx Data', () {
      test('check the right initial value', () {
        final data = LazxData<int>(1);
        expect(data.value, 1);
      });

      test('check the right value after update', () {
        final data = LazxData<int>(1);
        data.push(2);
        expect(data.value, 2);
      });
    });
  });
}
