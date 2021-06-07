import 'package:lazx/src/lazx_observable.dart';

import '../lazx.dart';

class LazxState extends LazxObservable {
  LazxState() {
    stateObserver.sink.add(LxState.Initial);
  }

  /// Set a new value
  void setState(LxState newState) {
    stateObserver.sink.add(newState);
  }
}
