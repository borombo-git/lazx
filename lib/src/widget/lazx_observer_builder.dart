import 'package:flutter/material.dart';

import '../../lazx.dart';

/// [LazxWidgetBuilder] is a type for a builder function that returns a [Widget]
/// and have a [BuildContext] & a [T] value from a [LazxData] as a parameter
typedef LazxValueBuilder<T> = void Function(T? value);

/// A [LazxObserverBuilder] is simply an abstraction for a [StreamBuilder] that will
/// listen to a [LazxObserver] value and build a widget in consequence.
///
/// The build function will be called each time that the [data] value is
/// updated.
///
/// It's the same as a [LazxBuilder], but for an [LazxObserver]
///
/// ```dart
/// LazxObserverBuilder<int>(
///   data: LazxObserverA
///   builder: (context, value) {
///   // return widget here based on the value
///   }
/// )
/// ```
class LazxObserverBuilder<T> extends StatelessWidget {
  /// The [data] that will be listened to execute the [builder] function
  final LazxObserver<T> data;

  /// The builder function that will be call each time the [data] is updated,
  /// passing the new value
  final LazxValueBuilder<T> builder;

  const LazxObserverBuilder({required this.data, required this.builder});

  ///   LazxObserverBuilder({required this.data, required this.builder}) {
  //     data.observer.listen((data) {
  //       builder(data);
  //     });

  @override
  Widget build(BuildContext context) {
    data.observer.listen((data) {
      builder(data);
    });

    return Container();

    /*return StreamBuilder<T>(
      stream: data.observer,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          builder(snapshot.data);
        }
        return Container();
      },
    );*/
  }
}
