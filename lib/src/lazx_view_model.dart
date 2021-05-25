import '../lazx.dart';

abstract class LazxViewModel {
  List<LazxData> get props;

  void init() {
    print('Init view Model');
  }

  void dispose() {
    print('Dispose view Model');
    props.forEach((value) => value.dispose());
  }
}
