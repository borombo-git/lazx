import 'package:lazx_weather/manager/weather_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:lazx/lazx.dart';

class SearchViewModel extends LazxViewModel {
  late WeatherManager _weatherManager;

  // State of the request
  LazxState weatherRequest = LazxState();
  TextEditingController cityTextController = TextEditingController();

  @override
  List<LazxObservable> get props => [weatherRequest];

  @override
  void init() {
    super.init();
    _weatherManager = WeatherManager();

    // Listen to the current weather, if updated, the request succeeded
    _weatherManager.displayedWeather.observer.listen((displayedWeather) {
      weatherRequest.setState(LxState.Success);
    });
  }

  Future<void> getWeather() async {
    // Set loading state
    weatherRequest.setState(LxState.Loading);
    // Get the city
    final city = cityTextController.text;
    if (city.isNotEmpty) {
      _queryWeather(city);
    } else {
      // Error if empty city
      weatherRequest.setState(LxState.Error);
    }
  }

  void _queryWeather(String city) async {
    // Query the manager
    final response = await _weatherManager.getWeather(city);
    // Set error stat if query not successful
    if (!response.success) {
      weatherRequest.setState(LxState.Error);
    }
  }

  @override
  void dispose() {
    cityTextController.dispose();
    super.dispose();
  }
}
