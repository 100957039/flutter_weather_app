import 'dart:async';
import 'package:flutter/material.dart';
import 'package:final_project_template/models/weather_response.dart';
import 'package:final_project_template/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();

}

class _WeatherPageState extends State<WeatherPage> {

  final _weatherService = WeatherService('6c287a0a60da34f0725f72b519b8d94e');
  WeatherResponse? _weather;
  WeatherLocation? _location;

  _fetchWeather() async {
    dynamic position = await _weatherService.getCurrentCoord();

    try{
      final weather = await _weatherService.getWeather(position.latitude, position.longitude);
      final location = await _weatherService.getCurrentCity(position.latitude, position.longitude);
      setState(() {
        _weather = weather;
        _location =location;
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
    if (_weather == null || _location == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      body: ListView(
        children: [
          // Current Weather Display
          Padding(
            padding: const EdgeInsets.fromLTRB(48.0, 16.0, 48.0, 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    _location?.locationName ?? "Loading city...", 
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    )
                  ),
                  Lottie.asset(
                    _weatherService.getWeatherAnimation(_weather?.current.weather[0].main),
                    width: 200,
                    height: 200,
                    fit: BoxFit.fill,
                    repeat: true,
                  ),
                  Text(
                    '${_weather?.current.weather[0].main}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                    child: Text(
                      '${_weather?.current.temp.round()}°C',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Daily Weather Forcast
          ..._weather!.daily.take(5).map((day) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(48, 16, 48, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey[600],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Row(
                    children: [
                      Text(
                        _weatherService.getWeekdayName(day.dt),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Lottie.asset(
                        _weatherService.getWeatherAnimation(day.weather[0].main),
                        width: 120,
                        height: 120,
                        repeat: true,
                      ),
                    ],
                  ),
                  trailing: Wrap(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Max: ${day.temp.max.round()}°C',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Min: ${day.temp.min.round()}°C',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(
                          weatherService: _weatherService,
                          weatherResponse: _weather!,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.weatherService, required this.weatherResponse});
  
  final WeatherResponse weatherResponse;
  final WeatherService weatherService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(weatherService.getWeekdayName(weatherResponse.daily[0].dt)),),
      body: Padding(
        padding:  const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Lottie.asset(
              weatherService.getWeatherAnimation(weatherResponse.daily[0].weather[0].main),
              width: 200,
              height: 200,
              fit: BoxFit.fill,
              repeat: true,
            ),
          ],
        )
      )
    );
  }
}
