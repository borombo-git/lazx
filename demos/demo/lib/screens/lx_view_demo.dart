import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';
import '../view_model/simple_demo_view_model.dart';

class LxDemoView extends LazxView<SimpleDemoViewModel> {
  @override
  SimpleDemoViewModel getViewModel() => SimpleDemoViewModel();

  @override
  Widget build(BuildContext context, SimpleDemoViewModel viewModel) {
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
            LazxBuilder<int>(
                data: viewModel.counter,
                builder: (context, value) {
                  return Text(
                    '$value',
                    style: Theme.of(context).textTheme.headline3,
                  );
                }),
            LazxBuilder<int>(
                data: viewModel.counter2,
                builder: (context, value) {
                  return Text(
                    '$value',
                    style: Theme.of(context).textTheme.headline3,
                  );
                }),
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
