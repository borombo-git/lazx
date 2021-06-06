import 'package:lazx_weather/model/weather.dart';
import 'package:lazx_weather/ui/result/result_view_model.dart';
import 'package:lazx_weather/ui/result/widget/change_location_button.dart';
import 'package:lazx_weather/ui/result/widget/weather_data.dart';
import 'package:lazx_weather/ui/result/widget/weather_info.dart';
import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';

import 'widget/separator.dart';

class ResultScreen extends LazxView<ResultViewModel> {
  @override
  ResultViewModel getViewModel() => ResultViewModel();

  @override
  void init(BuildContext context, ResultViewModel viewModel) {
    super.init(context, viewModel);
  }

  @override
  Widget build(BuildContext context, ResultViewModel viewModel) {
    return Scaffold(
      body: LazxBuilder<Weather>(
        data: viewModel.weather,
        builder: (context, data) {
          return Container(
            color: data!.getBackgroundColor(),
            child: SafeArea(
              left: false,
              right: false,
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: WeatherData(data),
                  ),
                  const Separator(),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          WeatherInfo(data),
                          const SizedBox(height: 16),
                          const ChangeLocationButton(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
