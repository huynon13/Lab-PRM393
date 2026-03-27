import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/location_model.dart';
import '../models/weather_model.dart';

class WeatherService {
  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<LocationModel> searchCity(String name) async {
    final uri = Uri.https(
      'geocoding-api.open-meteo.com',
      '/v1/search',
      <String, String>{
        'name': name,
        'count': '1',
        'language': 'en',
        'format': 'json',
      },
    );

    final response =
        await _client.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Geocoding failed (${response.statusCode})');
    }

    final decoded = json.decode(response.body) as Map<String, dynamic>;
    final results = decoded['results'];
    if (results is! List || results.isEmpty) {
      throw Exception('Không tìm thấy thành phố "$name"');
    }

    return LocationModel.fromJson(results.first as Map<String, dynamic>);
  }

  Future<WeatherModel> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https(
      'api.open-meteo.com',
      '/v1/forecast',
      <String, String>{
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': 'temperature_2m,weather_code,wind_speed_10m',
        'daily':
            'precipitation_probability_max,temperature_2m_max,temperature_2m_min',
        'timezone': 'auto',
      },
    );

    final response =
        await _client.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Weather request failed (${response.statusCode})');
    }

    final decoded = json.decode(response.body) as Map<String, dynamic>;
    return WeatherModel.fromJson(decoded);
  }

  Future<(LocationModel, WeatherModel)> fetchWeatherForCity(String city) async {
    final location = await searchCity(city);
    final weather = await fetchWeather(
      latitude: location.latitude,
      longitude: location.longitude,
    );
    return (location, weather);
  }

  void close() => _client.close();
}

