import 'package:flutter/material.dart';

import '../../lazx.dart';

/// A [LazxStateBuilder] is a builder that will build a widget depending on
/// the [LxState] of the [data].
///
/// The builder will have a 'build' function for all the different types of [LxState].
///
/// The [LazxStateBuilder] will call the right build function automatically depending on
/// the state of the [data] and will be updated when it changes
///
/// [LazxStateBuilder] is a [StatefulWidget] that will be abstracted when used so
/// you don't have to handle the state for it.
///
/// If you would like to build a widget, based on the [LxState] with a [LazxStateWidget]
/// refer to a [LazxDataBuilder] or [LazxBuilder]
///
/// /// If you would like to build a widget, based on the [LxState] but without
/// having to implements all the function, use a [LazxWidget]
///
/// ```dart
/// LazxBuilder(
///   data: LazxDataA
///   initial: (context, value) {
///     // return widget here based on the value
///   }
/// )
/// ```
class LazxStateBuilder<T> extends StatefulWidget {
  /// The [data] that will be listened to execute the right build function
  final LazxData<T> data;

  /// The builder functions that will be call each time the [data] is updated,
  /// depending on the [LxState] of the [data].
  ///
  /// Only the `initial` one is required, the other ones are optional.
  final LazxWidgetBuilder<T> initial;
  final LazxWidgetBuilder<T>? loading;
  final LazxWidgetBuilder<T>? success;
  final LazxWidgetBuilder<T>? error;

  const LazxStateBuilder(
      {required this.data,
      required this.initial,
      this.loading,
      this.success,
      this.error});

  @override
  _LazxStateBuilderState<T> createState() => _LazxStateBuilderState<T>();
}

/// [_LazxStateBuilderState] Represents the state for the [LazxStateBuilder] so
/// you don't have to handle it
class _LazxStateBuilderState<T> extends State<LazxStateBuilder<T>> {
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

  /// This function is a private wrapper for the default `Initial` state
  Widget _initial(BuildContext context) {
    return widget.initial(context, widget.data.value);
  }

  /// The build will simply call the right function that matches the state of
  /// the [dataState].
  ///
  /// By default, the 'initial' function for the `Initial` state is called if
  /// the state is not implemented
  @override
  Widget build(BuildContext context) {
    switch (dataState) {
      case LxState.Loading:
        return (widget.loading != null)
            ? widget.loading!(context, widget.data.value)
            : _initial(context);
      case LxState.Success:
        return (widget.success != null)
            ? widget.success!(context, widget.data.value)
            : _initial(context);
      case LxState.Error:
        return (widget.error != null)
            ? widget.error!(context, widget.data.value)
            : _initial(context);
      default:
        return _initial(context);
    }
  }
}
