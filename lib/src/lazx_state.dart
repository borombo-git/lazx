import '../lazx.dart';

class LazxState extends LazxObservable {
  LazxState() {
    stateObserver.sink.add(LxState.Initial);
  }

  /// Set a new value
  void setState(LxState newState) {
    if (!stateObserver.isClosed) {
      stateObserver.sink.add(newState);
    }
  }
}
