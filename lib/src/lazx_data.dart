import 'package:lazx/src/lazx_observable.dart';
import 'package:rxdart/rxdart.dart';

/// [LxState] represent the different state of a data.
///
/// By default a data can have 4 different states that covers most of the use cases
/// [Initial] : Represent the default state for a data. Could be before a
/// loading/success/error flow, or just the one default state. By default, every
/// data/view will starts with this state.
/// [Loading] : Represent a loading state for the data, if applicable.
/// [Success] : Represent an success state for a data. Could also be for a loaded data
/// [Error] : Represent an error state for a data, if applicable.
enum LxState { Initial, Loading, Success, Error }

/// [LazxData] represent a data with state management integrated.
///
///[T] represent the type of your data
class LazxData<T> extends LazxObservable {
  /// You can create [LazxData] with a default value.
  /// The default state will be [Initial]
  LazxData(this._value) {
    _state = LxState.Initial;
    push(_value);
  }

  /// Represent the [LxState] of your data
  LxState? _state;

  /// Represent your data
  T _value;

  /// An observer for your data's state
  final _stateObserver = BehaviorSubject<LxState>();
  Stream<LxState> get state => _stateObserver.stream;

  /// An observer for your data's value
  final _valueObserver = BehaviorSubject<T>();
  Stream<T> get stream => _valueObserver.stream;

  /// A getter to access your data value
  T get value => _value;

  /// Changed the [LxState] of your data and triggers all the listeners
  void setState(LxState lxState) {
    if (!_stateObserver.isClosed) {
      this._state = lxState;
      this._stateObserver.sink.add(this._state!);
    }
  }

  /// Set a new value an optionnaly, a new state for your data
  void push(T newValue, {LxState? lxState}) {
    if (!_valueObserver.isClosed) {
      _value = newValue;
      _valueObserver.sink.add(newValue);
      setState((lxState ?? this._state)!);
    }
  }

  /// Close all the observers
  @override
  void dispose() {
    _stateObserver.close();
    _valueObserver.close();
  }
}
