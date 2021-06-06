import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';
import 'package:lazx_weather/common/constants.dart';

import '../search_view_model.dart';

class WeatherButton extends LazxWidget {
  WeatherButton(LazxObservable data) : super(data: data);

  @override
  Widget build(BuildContext context, LxState state, data) {
    return GestureDetector(
      onTap: state != LxState.Loading
          ? () {
              viewModel<SearchViewModel>(context).getWeather();
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: state != LxState.Loading ? Colors.black : Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            state != LxState.Loading ? 'Get Weather' : 'Loading',
            style: buttonTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
