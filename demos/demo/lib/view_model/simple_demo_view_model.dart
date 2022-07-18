import 'package:lazx/lazx.dart';

class SimpleDemoViewModel extends LazxViewModel {
  LazxData<int> counter = LazxData<int>(0);
  LazxData<int> counter2 = LazxData<int>(0);

  @override
  List<LazxData> get props => [counter, counter2];

  void increment() {
    counter.push(counter.value + 1);
    counter2.push(counter2.value + 2);
  }
}
