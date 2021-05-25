import 'package:flutter/material.dart';

import '../../lazx.dart';

typedef LazxWidgetBuilder<T> = Widget Function(BuildContext context, T? value);

class LazxBuilder<T> extends StatelessWidget {
  final LazxData<T> data;
  final LazxWidgetBuilder<T> builder;

  const LazxBuilder({required this.data, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
        stream: data.stream,
        builder: (context, snapshot) {
          return builder(context, snapshot.data);
        });
  }
}
