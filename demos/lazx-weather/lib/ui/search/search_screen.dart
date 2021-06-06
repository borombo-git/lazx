import 'package:lazx_weather/common/constants.dart';
import 'package:lazx_weather/ui/result/result_screen.dart';
import 'package:lazx_weather/ui/search/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';
import 'package:lazx_weather/ui/search/widget/weather_button.dart';

class SearchScreen extends LazxView<SearchViewModel> {
  @override
  SearchViewModel getViewModel() => SearchViewModel();

  @override
  void init(BuildContext context, SearchViewModel viewModel) {
    LazxListener(
        data: viewModel.weatherRequest,
        success: (state) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => ResultScreen()));
        },
        error: (state) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('An error occurred. Please try again.')));
        });
  }

  @override
  Widget build(BuildContext context, SearchViewModel viewModel) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Select a city in the 🌍',
                  textAlign: TextAlign.center,
                  style: weatherDescriptionStyle.copyWith(color: Colors.black)),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Paris',
                  suffixIcon: IconButton(
                    onPressed: () => viewModel.cityTextController.clear(),
                    icon: Icon(Icons.clear),
                  ),
                ),
                controller: viewModel.cityTextController,
              ),
              WeatherButton(viewModel.weatherRequest),
            ],
          ),
        ),
      ),
    );
  }
}
