import 'package:lazx_weather/model/weather.dart';
import 'package:lazx_weather/repository/open_weather_repository.dart';
import 'package:lazx_weather/repository/weather_repository.dart';
import 'package:lazx/lazx.dart';

class WeatherManager extends LazxManager {
  static WeatherManager? _instance;
  factory WeatherManager() => _instance ??= WeatherManager._();

  WeatherManager._();

  WeatherRepository _repository = OpenWeatherRepository();

  // The current displayed/requested weather
  late LazxObserver<Weather?> displayedWeather = LazxObserver();

  @override
  List<LazxObserver> get props => [displayedWeather];

  Future<LxResponse<Weather>> getWeather(String city) async {
    // Query the repository
    final response = await _repository.getWeather(city);
    // Set the weather if response is successful
    if (response.success) {
      displayedWeather.set(response.data);
    }
    return response;
  }
}
