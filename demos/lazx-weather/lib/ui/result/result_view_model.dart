import 'package:lazx_weather/manager/weather_manager.dart';
import 'package:lazx_weather/model/weather.dart';
import 'package:lazx/lazx.dart';

class ResultViewModel extends LazxViewModel {
  late WeatherManager _weatherManager;

  @override
  List<LazxObservable> get props => [weather];

  // Initialise the weather with an empty Weather object
  LazxData<Weather> weather = LazxData(Weather.empty());

  @override
  void init() {
    _weatherManager = WeatherManager();

    // Listen to the displayed/requested weather
    _weatherManager.displayedWeather.observer.listen((displayedWeather) {
      // If not null, put it in the lazx data with success state
      if (displayedWeather != null) {
        weather.push(displayedWeather, lxState: LxState.Success);
      }
    });
  }
}
