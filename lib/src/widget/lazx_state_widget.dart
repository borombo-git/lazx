import 'package:flutter/material.dart';

abstract class LazxStateWidget<T> extends StatelessWidget {
  Widget initial(BuildContext context, T? data);
  Widget loading(BuildContext context, T? data) {
    return initial(context, data);
  }

  Widget success(BuildContext context, T? data) {
    return initial(context, data);
  }

  Widget error(BuildContext context, T? data) {
    return initial(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
