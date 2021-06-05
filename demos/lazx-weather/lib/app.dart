import 'package:lazx_weather/manager/weather_manager.dart';
import 'package:lazx_weather/ui/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';

import 'common/theme.dart';

class StarterApp extends LazxApp {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  List<LazxManager> get managers => [WeatherManager()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lazx Weather',
      theme: theme,
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      home: SearchScreen(),
    );
  }
}
