import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../model/forecast_weather_model.dart';
import '../services/location_access.dart';

class ForecastDetails with ChangeNotifier {
  ForecastWeatherModel? _forecastData;
  ForecastWeatherModel? get forecastdata => _forecastData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  LocationFetcher locationFetcher = LocationFetcher();

  Future<void> fetchForecast() async {
    await locationFetcher.determinePosition();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final latitude = position.latitude;
    final longitude = position.longitude;
    String baseUrl =
        "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=5b0579e2ad08cc47cd4c137bb61ac686&units=imperial";

    _isLoading = true;
    var response =
        await http.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 15));
    if (response.statusCode == 200) {
      _forecastData = ForecastWeatherModel.fromJson(json.decode(response.body));
      //   String currentDate = DateTime.now().toLocal().toString().split(' ')[0];
      //   List<dynamic> currentDayForecast = _forecastData!['forecast'].where((forecast) {
      //   return forecast['dt_txt'].startsWith(currentDate);
      // }).toList();
      print(response.body);
      _isLoading = false;
      notifyListeners();
    } else {
      print("error--------------------------------------------");
    }
  }
}
