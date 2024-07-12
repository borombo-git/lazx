import 'package:lazx/lazx.dart';

class MultiDemoViewModel extends LazxViewModel {
  LazxData<int> counter = LazxData<int>(0);
  LazxData<bool> show = LazxData<bool>(false);

  @override
  List<LazxData> get props => [counter, show];

  void increment() {
    counter.push(counter.value + 1);
  }

  void toggleShow() {
    show.push(!show.value);
  }
}
