import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Weather extends Equatable {
  final int weatherId;
  final String main;
  final String description;
  final double temperature;
  final int humidity;
  final double wind;
  final String city;

  Weather(this.weatherId, this.main, this.description, this.temperature,
      this.humidity, this.wind, this.city);

  factory Weather.empty() {
    return Weather(0, '', '', 0.0, 0, 0.0, '');
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    var tempValue = json['main']['temp'];
    final temp = tempValue is int ? tempValue.roundToDouble() : tempValue;
    return Weather(
      json['weather'][0]['id'],
      json['weather'][0]['main'],
      json['weather'][0]['description'],
      temp,
      json['main']['humidity'],
      json['wind']['speed'],
      json['name'],
    );
  }

  Color getBackgroundColor() {
    if (weatherId.toString() == '800') {
      return Color(0xFFFECACA);
    }
    switch (this.weatherId.toString().substring(0, 1)) {
      case '3':
        return Color(0xFF1F1E43);
      case '5':
        return Color(0xFF0C61F0);
      case '7':
        return Color(0xFF612960);
      case '8':
        return Color(0xFF03805C);
      default:
        return Color(0xFF000000);
    }
  }

  Widget getWeatherImage() {
    if (weatherId.toString() == '800') {
      return SvgPicture.asset('assets/svg/clear.svg');
    }
    switch (this.weatherId.toString().substring(0, 1)) {
      case '3':
        return SvgPicture.asset('assets/svg/drizzle.svg');
      case '5':
        return SvgPicture.asset('assets/svg/rain.svg');
      case '7':
        return SvgPicture.asset('assets/svg/atmosphere.svg');
      case '8':
        return SvgPicture.asset('assets/svg/clouds.svg');
      default:
        return Container();
    }
  }

  @override
  List<Object> get props => [description, temperature, humidity, wind];
}
