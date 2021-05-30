import 'package:demo/view_model/state_demo_view_model.dart';
import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';

class LazxDataBuilderScreenDemo extends LazxView<StateDemoViewModel> {
  @override
  StateDemoViewModel getViewModel() => StateDemoViewModel();

  @override
  Widget build(BuildContext context, StateDemoViewModel viewModel) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Lazx Demo : Data Builder + State Widget'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You have pushed the button this many times : '),
              LazxDataBuilder(
                data: viewModel.counter,
                lxWidget: LxCounterText(),
              ),
            ],
          ),
        ),
        floatingActionButton: LazxDataBuilder(
          data: viewModel.counter,
          lxWidget: LxFAB(),
        ));
  }
}

class LxCounterText extends LazxStateWidget {
  @override
  Widget initial(BuildContext context, data) {
    return Text(
      '$data',
      style: Theme.of(context).textTheme.headline3,
    );
  }

  @override
  Widget loading(BuildContext context, data) {
    return CircularProgressIndicator();
  }

  @override
  Widget success(BuildContext context, data) {
    return Text(
      '$data',
      style:
          Theme.of(context).textTheme.headline3!.copyWith(color: Colors.green),
    );
  }
}

class LxFAB extends LazxStateWidget {
  @override
  Widget initial(BuildContext context, data) {
    return FloatingActionButton(
      onPressed: () {
        viewModel<StateDemoViewModel>(context).increment();
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
      backgroundColor: Colors.purple,
    );
  }

  @override
  Widget loading(BuildContext context, data) {
    return FloatingActionButton(
      onPressed: null,
      tooltip: 'Increment',
      child: Icon(Icons.add),
      backgroundColor: Colors.purple[200],
    );
  }
}
