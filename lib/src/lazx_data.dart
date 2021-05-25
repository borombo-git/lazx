import 'package:rxdart/rxdart.dart';

enum LxState { Initial, Loading, Success, Error }

class LazxData<T> {
  LazxData(this._value) {
    _state = LxState.Initial;
    push(_value);
  }

  LxState? _state;
  T _value;

  final _stateObserver = BehaviorSubject<LxState>();
  Stream<LxState> get state => _stateObserver.stream;

  final _valueObserver = BehaviorSubject<T>();
  Stream<T> get stream => _valueObserver.stream;

  T get value => _value;

  void setState(LxState lxState) {
    this._state = lxState;
    this._stateObserver.sink.add(this._state!);
  }

  void push(T newValue, {LxState? lxState}) {
    _value = newValue;
    _valueObserver.sink.add(newValue);
    setState((lxState ?? this._state)!);
  }

  void dispose() {
    _stateObserver.close();
    _valueObserver.close();
  }
}
