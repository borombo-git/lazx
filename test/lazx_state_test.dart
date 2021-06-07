import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

void main() {
  group('Lazx State tests', () {
    test('Init value of the state', () {
      final lxState = LazxState();
      lxState.state.listen(
        expectAsync1(
          (value) {
            expect(value, LxState.Initial);
          },
        ),
      );
    });

    test('Test the updated value value of the state', () {
      final lxState = LazxState();
      lxState.setState(LxState.Success);
      lxState.state.listen(
        expectAsync1(
          (value) {
            expect(value, LxState.Success);
          },
        ),
      );
    });
  });
}
