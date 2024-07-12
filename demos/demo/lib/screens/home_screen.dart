import 'package:flutter/material.dart';

import 'lx_data_builder_demo.dart';
import 'lx_multi_builder_demo.dart';
import 'lx_state_builder_demo.dart';
import 'lx_view_demo.dart';
import 'lx_widget_demo.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Lazx Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Simple Screen + View Model
            ElevatedButton(
              child: Text('Simple Demo : View + VM'),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => LxDemoView()));
              },
            ),
            // State Builder
            ElevatedButton(
              child: Text('Simple Demo : State Builder'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => StateBuilderScreenDemo()));
              },
            ),
            // Lazx Widget
            ElevatedButton(
              child: Text('Simple Demo : Lazx Widget'),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => LazxWidgetScreenDemo()));
              },
            ),
            // Data Builder + State Widget
            ElevatedButton(
              child: Text('Simple Demo : Data Builder + State Widget'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => LazxDataBuilderScreenDemo()));
              },
            ),
            // Multi Builder
            ElevatedButton(
              child: Text('Simple Demo : Multi Builder'),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => LxMultiDemoView()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
