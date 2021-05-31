import 'package:lazx/lazx.dart';

class SimpleDemoViewModel extends LazxViewModel {
  LazxData<int> counter = LazxData<int>(0);

  @override
  List<LazxData> get props => [counter];

  void increment() {
    counter.push(counter.value + 1);
  }
}
