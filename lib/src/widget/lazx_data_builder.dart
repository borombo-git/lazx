import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';

class LazxDataBuilder<T> extends StatefulWidget {
  final LazxData<T> data;
  final LazxStateWidget lxWidget;

  const LazxDataBuilder({Key? key, required this.data, required this.lxWidget}) : super(key: key);

  @override
  _LazxStateBuilderState<T> createState() => _LazxStateBuilderState<T>();
}

class _LazxStateBuilderState<T> extends State<LazxDataBuilder<T>> {
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
