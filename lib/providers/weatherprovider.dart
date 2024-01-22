import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weathemodel.dart';
import 'package:weather_app/services/location_access.dart';

class WeatherDetails with ChangeNotifier {
  WeatherModel? _weatherData;
  WeatherModel? get weatherdata => _weatherData;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  LocationFetcher locationFetcher = LocationFetcher();

  Future<void> fetchData() async {
    await locationFetcher.determinePosition();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);

    print(
        " --------------------------------${position.latitude}___________ ${position.longitude}");

    final latitude = position.latitude;
    final longitude = position.longitude;

    String baseUrl =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=5b0579e2ad08cc47cd4c137bb61ac686&units=imperial";

    _isLoading = true;
    var response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      _weatherData = weatherModelFromJson(response.body);
      print(response.body);
      _isLoading = false;
      notifyListeners();
    } else {
      print("error--------------------------------------------");
    }
  }
}
