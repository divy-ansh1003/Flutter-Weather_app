// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'models/weather.dart';
import 'services/weather_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        fontFamily: 'Arial',
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
      ),
      home: const WeatherPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  
  // ignore: library_private_types_in_public_api
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _controller = TextEditingController();
  Future<Weather>? _weatherFuture;

  void _search() {
    final city = _controller.text.trim();
    if (city.isNotEmpty) {
      setState(() {
        _weatherFuture = _weatherService.fetchWeather(city);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onSubmitted: (_) => _search(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                labelText: 'Enter city',
                labelStyle: const TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: _search,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (_weatherFuture != null)
              FutureBuilder<Weather>(
                future: _weatherFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Colors.white);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}', style: const TextStyle(color: Colors.white));
                  } else if (snapshot.hasData) {
                    final weather = snapshot.data!;
                    return Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      
                      color: const Color.fromARGB(255, 230, 237, 243).withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              weather.cityName,
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Image.network(
                              'https://openweathermap.org/img/wn/${weather.iconCode}@2x.png',
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${weather.temperature.toStringAsFixed(1)} °C',
                              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              weather.description.toUpperCase(),
                              style: const TextStyle(fontSize: 16, letterSpacing: 1.2),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Text('No data', style: TextStyle(color: Colors.white));
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
