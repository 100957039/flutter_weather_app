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
}