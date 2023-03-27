import 'package:dio/dio.dart';

import '../model/weather_model.dart';

class WeatherRepo {
  final Dio dio;

  WeatherRepo(
    this.dio,
  );

  Future<WeatherModel> getWeather(String location) async {
    final String url =
        "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=e4fef53114583ed8a1e88b2cdee2eb2d&units=metric";
    final response = await dio.get(url);
    return WeatherModel.fromJson(response.data);
  }
}
