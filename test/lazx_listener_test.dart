import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

void main() {
  group('Lazx Listener Tests', () {
    test('Test initial builder is called', () {
      final lxState = LazxState();
      LazxListener(
          data: lxState,
          initial: (state) {
            expect(state, LxState.Initial);
          },
          loading: (state) {
            expect(state, LxState.Loading);
          },
          success: (state) {
            expect(state, LxState.Success);
          },
          error: (state) {
            expect(state, LxState.Error);
          });

      lxState.setState(LxState.Loading);
      lxState.setState(LxState.Error);
      lxState.setState(LxState.Success);
    });
  });
}
