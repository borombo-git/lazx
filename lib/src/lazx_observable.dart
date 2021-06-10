import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../lazx.dart';

/// [LazxObservable] is an abstract class for all Lazx class that handle a
/// [LazxState]. This state is commonly handled here.
abstract class LazxObservable {
  /// An observer for your state's value
  @protected
  final stateObserver = BehaviorSubject<LxState>();
  Stream<LxState> get state => stateObserver.stream;

  /// Dispose the stream when the implemented class is disposed
  void dispose() {
    stateObserver.close();
  }
}
