import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../lazx.dart';

abstract class LazxObservable {
  /// An observer for your data's value
  @protected
  final stateObserver = BehaviorSubject<LxState>();
  Stream<LxState> get state => stateObserver.stream;

  void dispose();
}
