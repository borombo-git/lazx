import 'package:lazx/lazx.dart';

class ExampleViewModel extends LazxViewModel {
  LazxData<int> counter = LazxData<int>(0);

  @override
  List<LazxData> get props => [counter];

  void increment() {
    counter.setState(LxState.Loading);
    Future.delayed(Duration(seconds: 3), () {
      counter.push(counter.value + 1, lxState: LxState.Success);
    });
  }
}
