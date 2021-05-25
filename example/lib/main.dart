import 'package:example/example_view_model.dart';
import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends LazxScreen<ExampleViewModel> {
  @override
  ExampleViewModel getViewModel() => ExampleViewModel();

  @override
  Widget build(BuildContext context, ExampleViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LazxStateBuilder<int>(
              data: viewModel.counter,
              initial: (context, toto) {
                return Text(
                  'You have pushed the button this many times: $toto',
                  style: TextStyle(fontSize: 28),
                );
              },
              loading: (_, __) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
              success: (context, toto) {
                return Text(
                  'You have pushed the button this many times: $toto',
                  style: TextStyle(color: Colors.green, fontSize: 32),
                );
              },
            ),
            LazxBuilder<int>(
              data: viewModel.counter,
              builder: (context, toto) {
                return Text(
                  'You have pushed the button this many times: $toto',
                  style: TextStyle(fontSize: 28),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: ClassicFAB(),
    );
  }
}

class NewFullWidget extends StatefulWidget {
  @override
  _NewFullWidgetState createState() => _NewFullWidgetState();
}

class _NewFullWidgetState extends State<NewFullWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ClassicFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => {
        viewModel<ExampleViewModel>(context).increment(),
      },
      child: const Icon(Icons.add),
      backgroundColor: Colors.pink[200],
    );
  }
}

class HomeFAB extends LazxStateWidget {
  @override
  Widget initial(BuildContext context, data) {
    return FloatingActionButton(
      onPressed: () => {
        viewModel<ExampleViewModel>(context).increment(),
      },
      child: const Icon(Icons.add),
      backgroundColor: Colors.pink[200],
    );
  }

  @override
  Widget loading(BuildContext context, data) {
    return FloatingActionButton(
      onPressed: null,
      child: const Icon(Icons.add),
      backgroundColor: Colors.pink[100],
    );
  }
}

class HomeFAB2 extends LazxWidget {
  HomeFAB2(LazxData data) : super(data: data);

  @override
  Widget build(BuildContext context, LxState state, data) {
    return FloatingActionButton(
      onPressed: state != LxState.Loading
          ? () => {
                viewModel<ExampleViewModel>(context).increment(),
              }
          : null,
      child: const Icon(Icons.add),
      backgroundColor: state != LxState.Loading ? Colors.pink[200] : Colors.pink[100],
    );
  }
}
