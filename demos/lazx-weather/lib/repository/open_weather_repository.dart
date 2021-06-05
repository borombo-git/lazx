import 'package:lazx_weather/common/open_weather_api.dart';
import 'package:lazx_weather/model/weather.dart';
import 'package:lazx_weather/repository/weather_repository.dart';
import 'package:lazx/lazx.dart';

class OpenWeatherRepository implements WeatherRepository {
  static OpenWeatherRepository? _instance;
  factory OpenWeatherRepository() => _instance ??= OpenWeatherRepository._();

  OpenWeatherRepository._();

  OpenWeatherApi _weatherApi = OpenWeatherApi();

  @override
  Future<LxResponse<Weather>> getWeather(String city) async {
    try {
      final response = await _weatherApi.getRequest(params: {'q': city});
      if (response.statusCode == 200) {
        print(response.data);
        return LxResponse(
            success: true, data: Weather.fromJson(response.data!));
      } else {
        print(response.statusMessage);
        return LxResponse(error: response.statusMessage);
      }
    } catch (e) {
      print(e.toString());
      return LxResponse(error: e.toString());
    }
  }
}
