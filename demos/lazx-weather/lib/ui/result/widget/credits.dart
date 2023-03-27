import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lazx_weather/common/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Credits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        children: [
          TextSpan(text: 'Designed inspired by '),
          TextSpan(
            text: 'Kian on Dribble',
            style: inspirationLinkTextStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(Uri.parse(
                    'https://dribbble.com/shots/10061507-Sunny-Cloudy-Rain'));
              },
          ),
        ],
        style: inspirationTextStyle,
      ),
    );
  }
}
