import 'dart:async';
import 'dart:convert';
import 'package:final_project_template/models/weather_response.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherService {

  static const BASE_URL = "https://api.openweathermap.org/data/3.0/onecall";
  static const GEOCODE_URL = "http://api.openweathermap.org/geo/1.0/reverse";
  final String apiKey;

  WeatherService(this.apiKey);
  
  Future<WeatherResponse> getWeather(double lat, double lon) async {
    
    final response = await http.get(Uri.parse('$BASE_URL?lat=$lat&lon=$lon&appid=$apiKey'));
    if (response.statusCode == 200) {
      return WeatherResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Position> getCurrentCoord() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  Future<WeatherLocation> getCurrentCity(double lat, double lon) async {
    final response = await http.get(Uri.parse('$GEOCODE_URL?lat=$lat&lon=$lon&appid=$apiKey'));
    if (response.statusCode == 200) {
      final List<dynamic> location = jsonDecode(response.body);
      return WeatherLocation.fromJson(location[0]);
    } else {
      throw Exception('Failed to load weather location');
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

  String getWeekdayName(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    int weekday = date.weekday;

    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }

  String formatTime(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String hours = date.hour.toString().padLeft(2, '0');
    String minutes = date.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}