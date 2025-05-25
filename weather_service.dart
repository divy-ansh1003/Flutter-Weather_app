import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  final String apiKey = '4bda6cdd86a1dc5c6c69798921846124';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather?q=city&appid=4bda6cdd86a1dc5c6c69798921846124&units=metric';

  Future<Weather> fetchWeather(String city) async {
    final url = Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric');
    // print('🔍 Requesting: $url');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      final message = jsonDecode(response.body)['message'];
      throw Exception('Error: $message');
    }
  }
}
