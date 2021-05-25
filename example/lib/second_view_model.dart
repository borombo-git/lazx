import 'package:rxdart/rxdart.dart';

class SecondViewModel {
  int _counterStrike = 0;
  final _counter = BehaviorSubject<int>();
  Stream<int> get counter => _counter.stream;

  void init() {
    _counter.sink.add(_counterStrike);
  }

  void increment() {
    _counter.sink.add(_counterStrike++);
  }

  void dispose() {
    _counter.close();
  }
}
