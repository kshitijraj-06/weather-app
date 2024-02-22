import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  runApp(const MaterialApp(
    home: WeatherApp(),
  ));
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late LinearGradient _backgroundGradient;
  final String apiKey =
      '960437de000ee1c797293d478704840f'; // OpenWeatherMap API Key
  var temperature;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var icon;
  var templ;
  var temph;
  var pressure;
  var name = '--';

  String getImagePath(double temp) {
    if (temp >= 25) {
      return 'assets/sunny.png';
    } else if (temp >= 10) {
      return 'assets/normal.png';
    } else {
      return 'assets/cold.png';
    }
  }

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
      icon = decoded['weather'][0]['icon'];
      templ = decoded['main']['temp_min'];
      temph = decoded['main']['temp_max'];
      pressure = decoded['main']['pressure'];
      name = decoded['name'];
    });
  }

  @override
  void initState() {
    super.initState();
    getLocationAndWeather();
    _updateBackgroundGradient();
  }

  void _updateBackgroundGradient() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    // Set different gradient colors based on the time of day
    if (hour >= 6 && hour < 12) {
      // Morning
      _backgroundGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.yellow[200]!, Colors.orange[900]!],
      );
    } else if (hour >= 12 && hour < 18) {
      // Afternoon
      _backgroundGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.blue[200]!, Colors.lightBlue[900]!],
      );
    } else {
      // Evening/Night
      _backgroundGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.purple[200]!, Colors.deepPurple[900]!],
      );
    }

    // Update background gradient every minute
    Future.delayed(const Duration(minutes: 1), () {
      _updateBackgroundGradient();
    });
  }

  Future<void> getLocationAndWeather() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double lon = position.longitude;
    await getWeather(lat, lon);
  }


  Future<void> refreshWeather() async {
    await getLocationAndWeather();
  }


  @override
  Widget build(BuildContext context) {
    String imagePath = getImagePath(temperature ?? 0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: _backgroundGradient),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0, left: 20),
                      child: IconButton(
                        onPressed: () {
                          //logic
                        },
                        icon: IconButton(
                           onPressed: refreshWeather,
                          icon: const Icon(Icons.refresh_outlined,
                          size: 26,),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 70,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0, left: 20),
                      child: Text(
                        name,
                        style: GoogleFonts.abel(
                            textStyle: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 140.0),
                  child: Row(
                    children: [
                      Text(
                        '${temperature != null ? temperature.toInt() : "--"}°C',
                        style: GoogleFonts.cantataOne(
                            textStyle: const TextStyle(
                                fontSize: 50, fontWeight: FontWeight.w400)),
                      ),
                      icon != null
                          ? Image.network(
                              'https://openweathermap.org/img/wn/$icon.png',
                              color: Colors.red,
                            )
                          : const Center()
                    ],
                  ),
                ),
                Text(
                  '$currently',
                  style: GoogleFonts.cantataOne(
                    textStyle: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  'H:${temph !=null ? temph.toStringAsFixed(1) : "--"} L:${templ !=null ? templ.toStringAsFixed(1) : "--"}',
                  style: GoogleFonts.cantataOne(
                    textStyle: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Image.asset(
                  imagePath,
                  width: 180,
                  height: 180,
                ),
                const SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Text(
                          'Humidity \n    $humidity %',
                          style: GoogleFonts.cantataOne(
                              textStyle: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400)),
                        ),
                      const SizedBox(width: 20,),
                      Text(
                        'Wind Speed \n    $windSpeed m/s',
                        style: GoogleFonts.cantataOne(
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400)),
                      ),
                      const SizedBox(width: 20,),
                      Text(
                        'Pressure \n${pressure != null ? pressure.toInt() : "--"}hPa',
                        style: GoogleFonts.cantataOne(
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          temperature == null // Check if temperature is null (indicating loading)
              ? Container(
            color: Colors.white.withOpacity(0.8), // Adjust opacity as needed
            child: Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('Updating...',
                  textStyle: GoogleFonts.abel(
                    textStyle: const TextStyle(
                      fontSize: 20,
                    )
                  ))
                ],), // Loading indicator
            ),
          )
              : const SizedBox.shrink(), // Invisible container when not loading
        ],
      ),
    );
  }
}
