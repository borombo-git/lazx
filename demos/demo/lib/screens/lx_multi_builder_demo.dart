import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';

import '../view_model/multi_demo_view_model.dart';

class LxMultiDemoView extends LazxView<MultiDemoViewModel> {
  @override
  MultiDemoViewModel getViewModel() => MultiDemoViewModel();

  @override
  Widget build(BuildContext context, MultiDemoViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Lazx Screen Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times : '),
            LazxMultiBuilder(
              data: [viewModel.counter, viewModel.show],
              builder: (context, value) {
                return Text(
                  'Counter: ${value[0]} & Show: ${value[1]}',
                  style: Theme.of(context).textTheme.headlineSmall,
                );
              },
            ),
            SizedBox(height: 40),
            Text('Show : '),
            LazxBuilder<bool>(
              data: viewModel.show,
              builder: (context, show) {
                return Switch(
                  value: show!,
                  onChanged: (value) {
                    viewModel.toggleShow();
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewModel.increment();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
