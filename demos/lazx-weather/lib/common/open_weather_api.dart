import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'constants.dart';

class OpenWeatherApi {
  late Dio _dio;

  static final OpenWeatherApi _instance = OpenWeatherApi._internal();

  factory OpenWeatherApi() {
    return _instance;
  }

  OpenWeatherApi._internal() {
    BaseOptions options = new BaseOptions(
        baseUrl: "https://api.openweathermap.org/data/2.5",
        connectTimeout: 5000,
        receiveTimeout: 3000,
        responseType: ResponseType.json,
        headers: {
          "Accept": "application/json"
        },
        queryParameters: {
          'appid': dotenv.env[kOpenWeatherApiKey],
          'units': 'metric'
        });
    _dio = new Dio(options);
  }

  Future<Response<Map<String, dynamic>>> getRequest(
      {Map<String, dynamic>? params}) async {
    return _dio.get('/weather', queryParameters: params);
  }
}
