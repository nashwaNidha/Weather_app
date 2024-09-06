import 'dart:core';
import 'package:flutter/material.dart';
import '../../../providers/weatherprovider.dart';

class CurrentData extends StatelessWidget {
  final WeatherDetails weatherInfo;
  final IconData weatherIcon;
  final String title;
  final String value;

  const CurrentData({
    super.key,
    required this.weatherInfo,
    required this.weatherIcon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 180,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              weatherIcon,
              size: 30,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(value, style: TextStyle(fontSize: 20))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
