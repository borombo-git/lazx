import 'package:lazx_weather/manager/weather_manager.dart';
import 'package:lazx_weather/model/weather.dart';
import 'package:lazx/lazx.dart';

class ResultViewModel extends LazxViewModel {
  late WeatherManager _weatherManager;

  @override
  List<LazxObservable> get props => [weather];

  LazxData<Weather> weather = LazxData(Weather.empty());

  @override
  void init() {
    _weatherManager = WeatherManager();

    _weatherManager.displayedWeather.observer.listen((displayedWeather) {
      if (displayedWeather != null) {
        weather.push(displayedWeather, lxState: LxState.Success);
      }
    });
  }

  @override
  void dispose() {
    print('Disposed Result View Model');
    super.dispose();
  }
}
