import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lazx_weather/common/constants.dart';
import 'package:lazx_weather/model/weather.dart';
import 'package:lazx_weather/utils/date_utils.dart';
import 'package:lazx_weather/utils/extensions.dart';

class WeatherData extends StatelessWidget {
  const WeatherData(this.weather);

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(child: weather.getWeatherImage()),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${LxDateUtils().getCurrentDate()}',
                    style: weatherDetailsStyle,
                  ),
                  Text(
                    '${weather.city}',
                    style: weatherDetailsStyle,
                  ),
                ],
              ),
              RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    '${weather.main}',
                    style: weatherDescriptionStyle,
                  )),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: AutoSizeText(
              weather.description.capitalize(),
              style: weatherDescriptionStyle,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}
