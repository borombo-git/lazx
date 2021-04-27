import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';

abstract class LazxScreen<T extends LazxViewModel> extends StatefulWidget {
  T getViewModel();

  void dispose(BuildContext context) {}

  Widget build(BuildContext context, T viewModel);

  @override
  LazxState<T> createState() => LazxState<T>();
}

class LazxState<T extends LazxViewModel> extends State<LazxScreen<T>> {
  T viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget.getViewModel()..init();
  }

  @override
  void dispose() {
    widget.dispose(context);
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, viewModel);
  }
}
