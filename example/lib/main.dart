import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';

void main() {
  runApp(ExampleApp());
}

class ExampleViewModel extends LazxViewModel {
  LazxData<int> counter = LazxData<int>(0);

  @override
  List<LazxData> get props => [counter];

  void increment() {
    counter.setState(LxState.Loading);
    Future.delayed(Duration(seconds: 1), () {
      counter.push(counter.value + 1, lxState: LxState.Success);
    });
  }
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lazx Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ExampleScreenDemo(),
    );
  }
}

class ExampleScreenDemo extends LazxView<ExampleViewModel> {
  @override
  ExampleViewModel getViewModel() => ExampleViewModel();

  @override
  Widget build(BuildContext context, ExampleViewModel viewModel) {
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
      style: Theme.of(context).textTheme.displaySmall,
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
      style: Theme.of(context)
          .textTheme
          .displaySmall!
          .copyWith(color: Colors.green),
    );
  }
}

class LxFAB extends LazxStateWidget {
  @override
  Widget initial(BuildContext context, data) {
    return FloatingActionButton(
      onPressed: () {
        viewModel<ExampleViewModel>(context).increment();
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
