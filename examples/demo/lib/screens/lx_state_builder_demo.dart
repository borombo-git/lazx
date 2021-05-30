import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';
import '../view_model/state_demo_view_model.dart';

class StateBuilderScreenDemo extends LazxView<StateDemoViewModel> {
  @override
  StateDemoViewModel getViewModel() => StateDemoViewModel();

  @override
  Widget build(BuildContext context, StateDemoViewModel viewModel) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Lazx Demo : State Builder'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You have pushed the button this many times : '),
              LazxStateBuilder<int>(
                  data: viewModel.counter,
                  initial: (context, value) {
                    return Text(
                      '$value',
                      style: Theme.of(context).textTheme.headline3,
                    );
                  },
                  loading: (context, value) {
                    return CircularProgressIndicator();
                  },
                  success: (context, value) {
                    return Text(
                      '$value',
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.green),
                    );
                  }),
            ],
          ),
        ),
        floatingActionButton: LxFAB());
  }
}

class LxFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Access view model from any widget down in the sub tree
        viewModel<StateDemoViewModel>(context).increment();
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
  }
}
