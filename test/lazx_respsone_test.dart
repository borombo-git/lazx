import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

void main() {
  group('LxResponse tests', () {
    test('Test init lx response object', () {
      final response = LxResponse<int>();
      expect(response.success, false);
      expect(response.data, null);
      expect(response.error, null);
    });

    test('Test success + data lx response object', () {
      final response = LxResponse<int>(success: true, data: 1);
      expect(response.success, true);
      expect(response.data, 1);
      expect(response.error, null);
    });

    test('Test error lx response object', () {
      final String error = 'An error occurred.';
      final response = LxResponse<int>(error: error);
      expect(response.success, false);
      expect(response.data, null);
      expect(response.error, error);
    });
  });
}
