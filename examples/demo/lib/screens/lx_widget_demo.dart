import 'package:demo/view_model/state_demo_view_model.dart';
import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';

class LazxWidgetScreenDemo extends LazxView<StateDemoViewModel> {
  @override
  StateDemoViewModel getViewModel() => StateDemoViewModel();

  @override
  Widget build(BuildContext context, StateDemoViewModel viewModel) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Lazx Demo : Lazx Widget'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You have pushed the button this many times : '),
              LxCounterText(viewModel.counter),
            ],
          ),
        ),
        floatingActionButton: LxFAB(viewModel.counter));
  }
}

class LxCounterText extends LazxWidget {
  LxCounterText(LazxData data) : super(data: data);

  @override
  Widget build(BuildContext context, LxState state, data) {
    switch (state) {
      case LxState.Loading:
        return CircularProgressIndicator();
      case LxState.Success:
        return Text(
          '$data',
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: Colors.green),
        );
      default:
        return Text(
          '$data',
          style: Theme.of(context).textTheme.headline3,
        );
    }
  }
}

class LxFAB extends LazxWidget {
  LxFAB(LazxData data) : super(data: data);

  @override
  Widget build(BuildContext context, LxState state, data) {
    return FloatingActionButton(
      onPressed: state != LxState.Loading
          ? () {
              viewModel<StateDemoViewModel>(context).increment();
            }
          : null,
      tooltip: 'Increment',
      child: Icon(Icons.add),
      backgroundColor:
          state != LxState.Loading ? Colors.purple : Colors.purple[200],
    );
  }
}
