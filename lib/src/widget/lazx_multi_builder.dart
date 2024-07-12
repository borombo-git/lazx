import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../lazx.dart';

/// [LazxWidgetMultiBuilder] is a type for a builder function that returns a [Widget]
/// and have a [BuildContext] & a list of value as a parameters
typedef LazxWidgetMultiBuilder = Widget Function(
    BuildContext context, List<dynamic> values);

/// Combines the streams of a list of [LazxData] into a single stream
Stream<List<dynamic>> combineStreams(List<LazxData<dynamic>> dataList) {
  return CombineLatestStream.list(dataList.map((data) => data.stream));
}

/// A [LazxMultiBuilder] is simply an abstraction for a [StreamBuilder] that will
/// listen to a list of [LazxData] values and build a widget in consequence.
///
/// The build function will be called each time that the one of the [data] value
/// is updated.
///
/// The value returned by the [builder] function is a list of the values of
/// the [data] in the same order
///
/// If you would like to build a widget, based on the [LxState] of your [LazxData]
/// refer to a [LazxStateBuilder] or [LazxDataBuilder]
///
/// ```dart
/// LazxMultiBuilder(
///   data: [LazxDataA, LazxDataB]
///   builder: (context, values) {
///   // return widget here based on the value
///   }
/// )
/// ```
class LazxMultiBuilder extends StatelessWidget {
  /// The list of [data] that will be listened to execute the [builder] function
  final List<LazxData<dynamic>> data;

  /// The builder function that will be call each time the [data] is updated,
  /// passing the new value
  final LazxWidgetMultiBuilder builder;

  const LazxMultiBuilder({required this.data, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: combineStreams(data),
      initialData: data.map((data) => data.value).toList(),
      builder: (context, snapshot) {
        return builder(context, snapshot.data ?? []);
      },
    );
  }
}
