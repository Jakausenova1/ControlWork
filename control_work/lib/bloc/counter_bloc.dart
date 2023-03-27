import 'package:control_work/repositories/get_weather_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'counter_event.dart';
import 'counter_state.dart';

class CounterWeatherBloc
    extends Bloc<CounterWeatherEvents, CounterWeatherStates> {
  int counter = 0;

  CounterWeatherBloc({required this.repo}) : super(InitialState()) {
    on<NumberIncrease>(onNumberIncrease);
    on<NumberDecrease>(onNumberDecrease);
    on<GetWeatherEvent>(getWeather);
  }

  get model => null;

  onNumberIncrease(
      NumberIncrease event, Emitter<CounterWeatherStates> emit) async {
    if (counter < 10) {
      counter = counter + 1;
    }
    emit(UpdateState(counter));
  }

  onNumberDecrease(
      NumberDecrease event, Emitter<CounterWeatherStates> emit) async {
    if (counter > 0) {
      counter = counter - 2;
    }
    emit(UpdateState(counter));
  }

  getWeather(event, emit) async {
    try {
      final model = await repo.getWeather('Бишкек');
      emit(WeatherSuccess(model: model));
    } catch (e) {
      emit(WeatherError());
    }
  }

  final WeatherRepo repo;
}
