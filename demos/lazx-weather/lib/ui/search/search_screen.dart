import 'package:lazx_weather/common/constants.dart';
import 'package:lazx_weather/ui/result/result_screen.dart';
import 'package:lazx_weather/ui/search/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';

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
        ));
  }
}
