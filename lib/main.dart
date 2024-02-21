import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: WeatherApp(),
  ));
}

class WeatherApp extends StatefulWidget {
  WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final String apiKey =
      'API_KEY_HERE'; // OpenWeatherMap API Key
  var temperature;
  var description;
  var currently;
  var humidity;
  var windSpeed;

  Future<void> getWeather(double lat, double lon) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    final decoded = json.decode(response.body);

    setState(() {
      temperature = decoded['main']['temp'];
      description = decoded['weather'][0]['description'];
      currently = decoded['weather'][0]['main'];
      humidity = decoded['main']['humidity'];
      windSpeed = decoded['wind']['speed'];
    });
  }

  @override
  void initState() {
    super.initState();
    getLocationAndWeather();
  }

  Future<void> getLocationAndWeather() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double lon = position.longitude;
    await getWeather(lat, lon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 20),
                child: IconButton(
                  onPressed: () {
                    //logic
                  },
                  icon: Icon(
                    Icons.refresh_sharp,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(
                width: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 20),
                child: Text(
                  'Weather App',
                  style: GoogleFonts.abel(
                      textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 100,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 13.0, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Temperature : $temperature °C',
                    style: GoogleFonts.abel(
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                  ),
                  Text(
                    'Description : $currently',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.abel(
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                  ),
                  Text(
                    'Humidity : $humidity %',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.abel(
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ),
            constraints: BoxConstraints(
              minHeight: 100,
              minWidth: 400,
            ),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(20)),
          ),
        ],
      ),
    );
  }
}
