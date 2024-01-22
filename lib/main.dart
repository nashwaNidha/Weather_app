import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Screens/forecastpage.dart';
import 'package:weather_app/Screens/weather_page.dart';
import 'package:weather_app/providers/forecastprovider.dart';
import 'package:weather_app/providers/weatherprovider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<WeatherDetails>(
        create: (context) => WeatherDetails(),
      ),
      ChangeNotifierProvider<ForecastDetails>(
        create: (context) => ForecastDetails(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Weatherpage(),
    );
  }
}
