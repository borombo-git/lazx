import 'package:flutter/material.dart';

import '../../lazx.dart';

class LazxStateBuilder<T> extends StatefulWidget {
  final LazxData<T> data;
  final LazxWidgetBuilder<T> initial;
  final LazxWidgetBuilder<T>? loading;
  final LazxWidgetBuilder<T>? success;
  final LazxWidgetBuilder<T>? error;

  const LazxStateBuilder(
      {required this.data, required this.initial, this.loading, this.success, this.error});

  @override
  _LazxStateBuilderState<T> createState() => _LazxStateBuilderState<T>();
}

class _LazxStateBuilderState<T> extends State<LazxStateBuilder<T>> {
  LxState dataState = LxState.Initial;

  @override
  initState() {
    super.initState();
    widget.data.state.listen((state) {
      setState(() {
        dataState = state;
      });
    });
  }

  Widget _initial(BuildContext context) {
    return widget.initial(context, widget.data.value);
  }

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
