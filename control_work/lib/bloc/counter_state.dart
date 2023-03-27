import 'package:control_work/model/weather_model.dart';

class CounterWeatherStates {}

class InitialState extends CounterWeatherStates {}

class UpdateState extends CounterWeatherStates {
  final int counter;
  UpdateState(this.counter);
}

class WeatherSuccess extends CounterWeatherStates {
  final WeatherModel model;

  WeatherSuccess({required this.model});
}

class WeatherError extends CounterWeatherStates {}
