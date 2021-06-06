import 'package:flutter/material.dart';

import 'credits.dart';

class Separator extends StatelessWidget {
  const Separator();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Credits(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Container(
            height: 1,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
