import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';
import 'package:lazx/src/lazx_data.dart';

abstract class LazxWidget extends StatefulWidget with LxViewModelProvider {
  final LazxData data;

  const LazxWidget({Key? key, required this.data}) : super(key: key);

  Widget build(BuildContext context, LxState state, data);

  @override
  LazxWidgetState createState() => LazxWidgetState();
}

class LazxWidgetState extends State<LazxWidget> {
  LxState _state = LxState.Initial;

  @override
  void initState() {
    super.initState();
    widget.data.state.listen((state) {
      setState(() {
        _state = state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, _state, widget.data.value);
  }
}
