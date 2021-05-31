import 'package:flutter/material.dart';

import '../../lazx.dart';

/// [LazxWidgetBuilder] is a type for a builder function that returns a [Widget]
/// and have a [BuildContext] & a [T] value from a [LazxData] as a parameter
typedef LazxWidgetBuilder<T> = Widget Function(BuildContext context, T? value);

/// A [LazxBuilder] is simply an abstraction for a [StreamBuilder] that will
/// listen to a [LazxData] value and build a widget in consequence.
///
/// The build function will be called each time that the [data] value is
/// updated.
///
/// If you would like to build a widget, based on the [LxState] of your [LazxData]
/// refer to a [LazxStateBuilder] or [LazxDataBuilder]
///
/// ```dart
/// LazxBuilder<int>(
///   data: LazxDataA
///   builder: (context, value) {
///   // return widget here based on the value
///   }
/// )
/// ```
class LazxBuilder<T> extends StatelessWidget {
  /// The [data] that will be listened to execute the [builder] function
  final LazxData<T> data;

  /// The builder function that will be call each time the [data] is updated,
  /// passing the new value
  final LazxWidgetBuilder<T> builder;

  const LazxBuilder({required this.data, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
        stream: data.stream,
        initialData: data.value,
        builder: (context, snapshot) {
          return builder(context, snapshot.data);
        });
  }
}
