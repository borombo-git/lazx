import 'package:flutter/material.dart';
import 'package:lazx_weather/common/constants.dart';
import 'package:lazx_weather/model/weather.dart';

class WeatherInfo extends StatelessWidget {
  const WeatherInfo(this.weather);

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(0),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Temperature ${weather.temperature.toStringAsFixed(1)}°C',
              style: weatherInfoStyle,
            ),
            Text(
              'Humidity ${weather.humidity}%',
              style: weatherInfoStyle,
            ),
            Text(
              'Wind Speed ${weather.wind.toStringAsFixed(1)} m/s',
              style: weatherInfoStyle,
            ),
          ],
        ),
      ),
    );
  }
}
