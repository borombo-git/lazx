import 'package:lazx/lazx.dart';
import 'package:rxdart/rxdart.dart';

class SecondViewModel extends LazxViewModel {
  int _counterStrike = 0;
  final _counter = BehaviorSubject<int>();
  Stream<int> get counter => _counter.stream;

  @override
  void init() {
    super.init();
    _counter.sink.add(_counterStrike);
  }

  void increment() {
    _counter.sink.add(_counterStrike++);
  }

  @override
  void dispose() {
    _counter.close();
  }
}
