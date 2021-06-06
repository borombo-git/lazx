import 'package:flutter/material.dart';
import 'package:lazx_weather/common/constants.dart';

class ChangeLocationButton extends StatelessWidget {
  const ChangeLocationButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Change location',
              style: buttonTextStyle.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}
