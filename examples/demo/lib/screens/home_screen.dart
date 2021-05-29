import 'package:demo/screens/lx_screen_demo.dart';
import 'package:flutter/material.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Simple Demo : Screen + VM'),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => LxDemoScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}
