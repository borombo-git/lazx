import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';

/// [LazxStateWidget] is a widget that will have different builder function
/// depending on a [LxState].
///
/// [LazxStateWidget] as been made to be used with a [LazxDataBuilder] to build
/// a widget based on the [LxState] of a [LazxData] of type [T].
///
/// It's an better version of an [LazxWidget] that reduce the boilerplate code
/// to check the condition of a state and show something in consequence.
abstract class LazxStateWidget<T> extends StatelessWidget {
  /// A build function called when the [LxState] of the data is initial.
  ///
  /// As it's the default builder, it's mandatory to override it to have at least
  /// a default view fot the widget.
  Widget initial(BuildContext context, T? data);

  /// This function is called when the [LxState] of the data is loading.
  ///
  /// As it's optional, if it's not needed/overrided the default function (initial)
  /// is called.
  Widget loading(BuildContext context, T? data) {
    return initial(context, data);
  }

  /// This function is called when the [LxState] of the data is success.
  ///
  /// As it's optional, if it's not needed/overrided the default function (initial)
  /// is called.
  Widget success(BuildContext context, T? data) {
    return initial(context, data);
  }

  /// This function is called when the [LxState] of the data is error.
  ///
  /// As it's optional, if it's not needed/overrided the default function (initial)
  /// is called.
  Widget error(BuildContext context, T? data) {
    return initial(context, data);
  }

  /// The classic build function that will never been called, but it's overrided
  /// here to avoid it do be mandatory overrided when you inherit from this class
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
