import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';

/// A [LazxDataBuilder] is a builder that will build a [LazxStateWidget] when
/// the [LxState] of the [data] will be updated
///
/// The [lxWidget] will call the right build function automatically depending on
/// the state of the [data] and will be updated when it changes
///
/// [LazxDataBuilder] is a [StatefulWidget] that will be abstracted when used so
/// you don't have to handle the state for it.
///
/// If you would like to build a widget, based on the [LxState] without a [LazxStateWidget]
/// refer to a [LazxStateBuilder] or [LazxBuilder]
///
/// ```dart
/// LazxBuilder(
///   data: LazxDataA
///   lxWidget: LazxWidgetA
/// )
/// ```
class LazxDataBuilder<T> extends StatefulWidget {
  /// The [data] that will be listened to execute the build function
  final LazxData<T> data;

  /// The [LazxStateWidget] that will be build depending on the [LxState] of the
  /// [data]
  final LazxStateWidget lxWidget;

  const LazxDataBuilder({Key? key, required this.data, required this.lxWidget})
      : super(key: key);

  @override
  _LazxStateBuilderState<T> createState() => _LazxStateBuilderState<T>();
}

/// [_LazxStateBuilderState] Represents the state for the [LazxDataBuilder] so
/// you don't have to handle it
class _LazxStateBuilderState<T> extends State<LazxDataBuilder<T>> {
  /// Represents the current state of your data.
  /// By default, the state is `Initial`
  LxState dataState = LxState.Initial;

  /// The state is initialized and we listen to the state of the `data` to update
  /// the [dataState] and rebuild the widget
  @override
  initState() {
    super.initState();
    widget.data.state.listen((state) {
      setState(() {
        dataState = state;
      });
    });
  }

  /// The [build] will simply return the build function from the `lxWidget` that
  /// matches the state of the [dataState].
  ///
  /// By default, the `Initial` function of the `lxWidget` is returned
  @override
  Widget build(BuildContext context) {
    switch (dataState) {
      case LxState.Loading:
        return widget.lxWidget.loading(context, widget.data.value);
      case LxState.Success:
        return widget.lxWidget.success(context, widget.data.value);
      case LxState.Error:
        return widget.lxWidget.error(context, widget.data.value);
      default:
        return widget.lxWidget.initial(context, widget.data.value);
    }
  }
}
