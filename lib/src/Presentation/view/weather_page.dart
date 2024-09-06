import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qweather_icons/qweather_icons.dart';
import 'package:weather_app/src/Presentation/core/widget/custom_background.dart';
import 'package:weather_app/src/Presentation/core/widget/custom_button.dart';
import 'package:weather_app/src/Presentation/core/widget/custom_container.dart';
import 'package:weather_app/src/Presentation/core/widget/location_text.dart';
import 'package:weather_app/src/Presentation/view/forecastpage.dart';
import '../../providers/forecastprovider.dart';
import '../../providers/weatherprovider.dart';
import '../core/widget/current_data.dart';

class Weatherpage extends StatefulWidget {
  const Weatherpage({super.key});

  @override
  State<Weatherpage> createState() => _WeatherpageState();
}

class _WeatherpageState extends State<Weatherpage> {
  @override
  void initState() {
    super.initState();
    Provider.of<WeatherDetails>(context, listen: false).fetchData();
    Provider.of<ForecastDetails>(context, listen: false).fetchForecast();
  }

//To convert MillisecondsSinceEpoch to DateTime
  DateTime? unpackDate(dynamic k) {
    int millis = k * 1000;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  //convert fahrenheit to celcius
  int convertToFahrenheit(double fahrenheit) {
    return ((fahrenheit - 32) * 5 / 9).round();
  }

//format date
  String formatDate(dynamic date) {
    String formattedDate = DateFormat('E d, y').format(date);
    return formattedDate;
  }

  String formatDate2(dynamic date) {
    String formattedDate = DateFormat('hh:mm').format(date);
    return formattedDate;
  }

  DateTime timeZoneToTime(dynamic timezoneOffsetSeconds) {
    // Timezone offset from OpenWeatherMap API (in seconds)

    // Create a Duration with the given offset
    Duration offsetDuration = Duration(seconds: timezoneOffsetSeconds);

    // Get the current UTC time
    DateTime utcTime = DateTime.now().toUtc();

    // Apply the offset to get the local time
    DateTime localTime = utcTime.add(offsetDuration);
    return localTime;
  }

  // to format description
  String formatDescName(String descName) {
    List<String> words = descName.split(' ');
    for (int i = 0; i < words.length; i++) {
      words[i] =
          "${words[i][0].toUpperCase()}${words[i].substring(1).toLowerCase()}";
    }
    return words.join(' ');
  }

// button hover
  bool isHovered = false;

// mt to km
  double metersToKilometers(int meters) {
    // 1 meter is equal to 0.001 kilometers
    return meters * 0.001;
  }

  @override
  Widget build(BuildContext context) {
    final weatherInfo = Provider.of<WeatherDetails>(context);

    return CustomBackground(
        child: Scaffold(
      backgroundColor: const Color(0x00000000),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: weatherInfo.weatherdata == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  LocationText(location: weatherInfo.weatherdata!.name!),
                  Text(
                    formatDate(unpackDate(weatherInfo.weatherdata!.dt)),
                    style: GoogleFonts.lato(
                      textStyle:
                          const TextStyle(fontSize: 20, letterSpacing: .5),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    title: 'Forecast',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ForecastPage(),
                      ));
                    },
                  ),
                  CustomContainer(
                    child: Column(
                      children: [
                        Image.network(
                            "https://openweathermap.org/img/wn/10d@4x.png",
                            // ${weatherInfo.weatherdata!.weather[0].icon}
                            height: 210,
                            width: 300,
                            fit: BoxFit.cover,
                            alignment: AlignmentDirectional.center),
                        Text(
                          "${convertToFahrenheit(weatherInfo.weatherdata!.main!.temp!)}\u00B0C",
                          style: const TextStyle(fontSize: 45),
                        ),
                        Text(
                          formatDescName(weatherInfo
                              .weatherdata!.weather![0].description!),
                          style: const TextStyle(fontSize: 20),
                          // softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                  CustomContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            CurrentData(
                                weatherInfo: weatherInfo,
                                weatherIcon:
                                    QWeatherIcons.tag_low_humidity2.iconData,
                                title: "Humidity",
                                value:
                                    "${weatherInfo.weatherdata!.main!.humidity!.toDouble()}%"),
                            CurrentData(
                                weatherInfo: weatherInfo,
                                weatherIcon: QWeatherIcons.tag_wind3.iconData,
                                title: "Wind",
                                value:
                                    "${weatherInfo.weatherdata!.wind!.speed} km/h"),
                            CurrentData(
                                weatherInfo: weatherInfo,
                                weatherIcon: QWeatherIcons.tag_sunny.iconData,
                                title: "Sunrise",
                                value:
                                    "${formatDate2(timeZoneToTime(weatherInfo.weatherdata!.sys!.sunrise))} AM"),
                          ],
                        ),
                        Column(
                          children: [
                            CurrentData(
                                weatherInfo: weatherInfo,
                                weatherIcon:
                                    QWeatherIcons.tag_high_temperature.iconData,
                                title: "Feels like",
                                value:
                                    "${convertToFahrenheit(weatherInfo.weatherdata!.main!.feelsLike!)}\u00B0C"),
                            CurrentData(
                                weatherInfo: weatherInfo,
                                weatherIcon: QWeatherIcons.tag_wind.iconData,
                                title: "Visibility",
                                value:
                                    "${metersToKilometers(weatherInfo.weatherdata!.visibility!)} km"),
                            CurrentData(
                                weatherInfo: weatherInfo,
                                weatherIcon:
                                    QWeatherIcons.tag_full_moon.iconData,
                                title: "Sunset",
                                value:
                                    "${formatDate2(timeZoneToTime(weatherInfo.weatherdata!.sys!.sunset))} PM"),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    ));
  }
}
