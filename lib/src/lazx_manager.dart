import 'package:lazx/src/lazx_observer.dart';

abstract class LazxManager {
  List<LazxObserver> get props;

  /// Can be override to initialise some calls or variables
  void init() {}

  /// Can be override to finish some calls/listeners
  /// It's also used to dispose all the [LazxObserver]
  void dispose() {
    props.forEach((value) => value.dispose());
  }
}
