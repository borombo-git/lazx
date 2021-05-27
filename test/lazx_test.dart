import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

void main() {
  group('LazxData Tests', () {
    group('Simple Lazx Data', () {
      test('check the right initial value', () {
        final data = LazxData<int>(1);
        expect(data.value, 1);
      });
    });
  });
}
