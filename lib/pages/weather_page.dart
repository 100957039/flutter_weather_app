import 'package:flutter/material.dart';
import 'package:final_project_template/models/weather_response.dart';
import 'package:final_project_template/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();

}

class _WeatherPageState extends State<WeatherPage> {

  final _weatherService = WeatherService('6c287a0a60da34f0725f72b519b8d94e');
  WeatherResponse? _weather;

  _fetchWeather() async {
    dynamic position = await _weatherService.getCurrentCoord();

    try{
      final weather = await _weatherService.getWeather(position.latitude, position.longitude);
      setState(() {
        _weather = weather;
      });
    }

    catch(e){
      print("Error fetching weather data: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Text(_weather?.cityName ?? "Loading city..."),
            Text('${_weather?.current.temp.round()}°C'),
          ],
        ),
      ),
    );
  }
}
