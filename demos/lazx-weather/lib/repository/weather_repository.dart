import 'package:lazx_weather/model/weather.dart';
import 'package:lazx/lazx.dart';

abstract class WeatherRepository {
  Future<LxResponse<Weather>> getWeather(String city);
}
