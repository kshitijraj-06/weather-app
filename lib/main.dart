import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MaterialApp(
    home: WeatherApp(),
  ));
}

class WeatherApp extends StatelessWidget {
  WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 20),
              child: IconButton(
                onPressed: () {
                  //logic
                },
                icon: Icon(
                  Icons.home_outlined,
                  size: 40,
                ),
              ),
            ),
            SizedBox(width: 80,),
            Padding(
              padding: const EdgeInsets.only(top:66.0, left: 20),
              child: Text('Weather App',
              style: GoogleFonts.abel(
                textStyle: TextStyle(fontSize: 20)
              ),),
            ),
          ],
        )
    );
  }
}
