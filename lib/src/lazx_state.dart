import 'package:lazx/src/lazx_observable.dart';
import 'package:rxdart/rxdart.dart';

import '../lazx.dart';

class LazxState extends LazxObservable {
  /// Represent your data
  LxState _state = LxState.Initial;

  /// A getter to access your data value
  //LxState get state => _state;

  /// Set a new value
  void setState(LxState newState) {
    _state = newState;
    stateObserver.sink.add(newState);
  }

  /// Close the observer
  @override
  void dispose() {
    stateObserver.close();
  }
}
