import 'package:example/second_view_model.dart';
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
      home: TotoALa(),
    );
  }
}

class TotoALa extends LazxScreen<SecondViewModel> {
  @override
  SecondViewModel getViewModel() => SecondViewModel();

  @override
  Widget build(BuildContext context, SecondViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<int>(
                stream: viewModel.counter,
                builder: (context, snapshot) {
                  return Text(
                    'You have pushed the button this many times: ${snapshot.data}',
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.increment(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.pink[200],
      ),
    );
  }
}
