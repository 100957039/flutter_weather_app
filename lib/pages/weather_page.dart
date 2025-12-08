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

  String getWeatherAnimation(String? weatherCondition) {
    switch (weatherCondition?.toLowerCase()) {
      case 'clear':
        return 'assets/sunny.json';
      case 'fog':
        return 'assets/fog.json';
      case 'mist':
        return 'assets/fog.json';
      case 'smoke':
        return 'assets/fog.json';
      case 'haze':
        return 'assets/fog.json';
      case 'dust':
        return 'assets/fog.json';
      case 'sand':
        return 'assets/fog.json';
      case 'ash':
        return 'assets/fog.json';
      case 'tornado':
        return 'assets/fog.json';
      case 'squall':
        return 'assets/snowing.json';
      case 'drizzle':
        return 'assets/rain.json';
      case 'rain':
        return 'assets/rain.json';
      case 'snow':
        return 'assets/snowing.json';
      case 'clouds':
        return 'assets/cloudy.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      default:
        return 'assets/unknown.json';
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
      backgroundColor: Colors.blueGrey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _location?.locationName ?? "Loading city...", 
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white)
                ),

            Lottie.asset(
              getWeatherAnimation(_weather?.current.weather[0].main),
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
            Text(
              '${_weather?.current.temp.round()}°C',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
