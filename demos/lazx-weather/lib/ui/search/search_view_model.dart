import 'package:lazx_weather/manager/weather_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:lazx/lazx.dart';

class SearchViewModel extends LazxViewModel {
  late WeatherManager _weatherManager;

  LazxState weatherRequest = LazxState();

  TextEditingController cityTextController = TextEditingController();

  @override
  void init() {
    super.init();
    _weatherManager = WeatherManager();

    _weatherManager.displayedWeather.observer.listen((displayedWeather) {
      weatherRequest.setState(LxState.Success);
    });
  }

  Future<void> getWeather() async {
    weatherRequest.setState(LxState.Loading);
    final city = cityTextController.text;
    if (city.isNotEmpty) {
      _queryWeather(city);
    } else {
      weatherRequest.setState(LxState.Error);
    }
  }

  void _queryWeather(String city) async {
    final response = await _weatherManager.getWeather(city);
    if (!response.success) {
      weatherRequest.setState(LxState.Error);
    }
  }

  @override
  void dispose() {
    cityTextController.dispose();
    super.dispose();
  }

  @override
  List<LazxObservable> get props => [weatherRequest];
}
