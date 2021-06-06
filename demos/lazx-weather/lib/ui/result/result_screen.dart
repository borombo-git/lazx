import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:lazx_weather/common/constants.dart';
import 'package:lazx_weather/model/weather.dart';
import 'package:lazx_weather/ui/result/result_view_model.dart';
import 'package:lazx_weather/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';
import 'package:lazx_weather/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultScreen extends LazxView<ResultViewModel> {
  @override
  ResultViewModel getViewModel() => ResultViewModel();

  @override
  void init(BuildContext context, ResultViewModel viewModel) {
    print('Init Result Screen');
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
                      child: Stack(
                        children: [
                          Center(child: data.getWeatherImage()),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${LxDateUtils().getCurrentDate()}',
                                      style: weatherDetailsStyle,
                                    ),
                                    Text(
                                      '${data.city}',
                                      style: weatherDetailsStyle,
                                    ),
                                  ],
                                ),
                                RotatedBox(
                                    quarterTurns: 1,
                                    child: Text(
                                      '${data.main}',
                                      style: weatherDescriptionStyle,
                                    )),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: AutoSizeText(
                                data.description.capitalize(),
                                style: weatherDescriptionStyle,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Separator(),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.all(0),
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Temperature ${data.temperature.toStringAsFixed(1)}°C',
                                      style: weatherInfoStyle,
                                    ),
                                    Text(
                                      'Humidity ${data.humidity}%',
                                      style: weatherInfoStyle,
                                    ),
                                    Text(
                                      'Wind Speed ${data.wind.toStringAsFixed(1)} m/s',
                                      style: weatherInfoStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 24.0),
                            BackButton(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  void dispose(BuildContext context) {
    print('Dispose Result Screen');
    super.dispose(context);
  }
}

class Credits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        children: [
          TextSpan(text: 'Designed inspired by '),
          TextSpan(
            text: 'Kian on Dribble',
            style: inspirationLinkTextStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch('https://dribbble.com/shots/10061507-Sunny-Cloudy-Rain');
              },
          ),
        ],
        style: inspirationTextStyle,
      ),
    );
  }
}

class Separator extends StatelessWidget {
  const Separator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Credits(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Container(
            height: 1,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Change location',
              style: buttonTextStyle.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}
