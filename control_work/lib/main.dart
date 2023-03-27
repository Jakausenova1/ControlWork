import 'dart:async';

import 'package:control_work/dio/dio_settings.dart';
import 'package:control_work/repositories/get_weather_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/counter_bloc.dart';
import 'bloc/counter_event.dart';
import 'bloc/counter_state.dart';
import 'theme/theme_const.dart';
import 'theme/theme_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

ThemeManager _themeManager = ThemeManager();

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => DioSettings(),
        ),
        RepositoryProvider(
          create: (context) =>
              WeatherRepo(RepositoryProvider.of<DioSettings>(context).dio),
        ),
      ],
      child: BlocProvider(
        create: (context) => CounterWeatherBloc(
          repo: RepositoryProvider.of<WeatherRepo>(context),
        ),
        child: MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: _themeManager.themeMode,
          debugShowCheckedModeBanner: false,
          home: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Switch(
              value: _themeManager.themeMode == ThemeMode.dark,
              onChanged: (newValue) {
                _themeManager.toggleTheme(newValue);
              })
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 100),
          BlocBuilder<CounterWeatherBloc, CounterWeatherStates>(
            builder: (context, state) {
              if (state is WeatherSuccess) {
                return Text(
                  "${state.model.name}: ${state.model.main?.temp}",
                );
              }
              if (state is WeatherError) {
                return const Text('Ошибка погоды :');
              }
              return const Text('Погода :');
            },
            buildWhen: (oldState, newState) {
              return newState is WeatherSuccess || newState is WeatherError;
            },
          ),
          BlocBuilder<CounterWeatherBloc, CounterWeatherStates>(
            builder: (context, state) {
              if (state is UpdateState) {
                return _counter(context, state.counter);
              }
              return _counter(context, 0);
            },
            buildWhen: (oldState, newState) {
              return newState is UpdateState;
            },
          ),
        ],
      ),
    );
  }
}

Widget _counter(BuildContext context, int counter) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        Text(counter.toString(), style: const TextStyle(fontSize: 30)),
        const SizedBox(
          height: 50,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
                color: Colors.red,
                elevation: 0.0,
                height: 50,
                shape: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: Icon(
                      Icons.minimize_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: () =>
                    context.read<CounterWeatherBloc>().add(NumberDecrease())),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
                color: Colors.green,
                elevation: 0.0,
                height: 50,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () =>
                    context.read<CounterWeatherBloc>().add(NumberIncrease())),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Colors.blue,
              elevation: 0.0,
              height: 50,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.sunny,
                color: Colors.white,
              ),
              onPressed: () => context.read<CounterWeatherBloc>().add(
                    GetWeatherEvent(),
                  ),
            ),

            // IconButton(
            //   onPressed: () {
            //     setState(() {

            //     })
            //   },
            //   icon: Icon(_iconBool ? _iconDarkData : _iconLightData),
            // )
          ],
        )
      ],
    ),
  );
}
