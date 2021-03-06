import 'package:lazx/lazx.dart';
import 'package:rxdart/rxdart.dart';

/// [LazxObserver] represent an observer to your data (made to be used in your
/// repo or data provider for a [LazxManager] manager).
///
/// [T] represent the type of your data.
///
/// This class is similar to [LazxData] without the state handled.
class LazxObserver<T> {
  /// You can create [LazxObserver] with a default value.
  LazxObserver({T? initialValue}) {
    if (initialValue != null) {
      _value = initialValue;
      set(_value!);
    }
  }

  /// Represent your data
  T? _value;

  /// An observer for your data's value
  final _valueObserver = BehaviorSubject<T>();
  Stream<T> get observer => _valueObserver.stream;

  /// A getter to access your data value
  T? get value => _value;

  /// Set a new value
  void set(T newValue) {
    _value = newValue;
    _valueObserver.sink.add(newValue);
  }

  /// Close the observer
  void dispose() {
    _valueObserver.close();
  }
}
