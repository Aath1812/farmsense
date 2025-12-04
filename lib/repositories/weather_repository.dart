import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:farmsense/models/weather_model.dart';
import 'package:flutter/foundation.dart';
// Removed unused dotenv import

class WeatherRepository {
  // FIX: Assigned the key directly as a String. No more 'dotenv' or '!' needed.
  final String _apiKey = '2b9dc220894e73a8b3e23944eb9ee600';

  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> fetchWeather(String city) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric'));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        debugPrint('Failed to load weather for $city: ${response.statusCode}');
        return WeatherModel.mock();
      }
    } catch (e) {
      debugPrint('Error fetching weather for $city: $e');
      return WeatherModel.mock();
    }
  }
}