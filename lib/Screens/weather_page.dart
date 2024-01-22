import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qweather_icons/qweather_icons.dart';
import 'package:weather_app/Screens/forecastpage.dart';

import '../providers/forecastprovider.dart';
import '../providers/weatherprovider.dart';
import '../widgets/current_data.dart';

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
    final forecastInfo = Provider.of<ForecastDetails>(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: <Color>[
            Color.fromARGB(255, 22, 82, 131),
            Color.fromARGB(187, 76, 155, 219),
            Color.fromARGB(255, 25, 127, 210),
            Color.fromARGB(255, 68, 125, 169),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Color(0x00000000),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: weatherInfo.weatherdata == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        weatherInfo.weatherdata!.name,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 35, letterSpacing: .5),
                        ),
                      ),
                    ),
                    Text(
                      formatDate2(
                          timeZoneToTime(weatherInfo.weatherdata!.timezone)),
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 35, letterSpacing: .5),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      formatDate(unpackDate(weatherInfo.weatherdata!.dt)),
                      style: GoogleFonts.lato(
                        textStyle:
                            const TextStyle(fontSize: 20, letterSpacing: .5),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current weather',
                            style: TextStyle(fontSize: 24),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ForecastPage(),
                              ));
                            },
                            child: Container(
                              height: 40,
                              width: 140,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      // isHovered
                                      //     ? Color.fromARGB(173, 16, 29, 85)
                                      //     : Colors.lightBlue
                                      Color.fromARGB(173, 16, 29, 85)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Forecast',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          letterSpacing: .5),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_outward_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Container(
                          //   height: 40,
                          //   width: 140,
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(10),
                          //       color: Color.fromARGB(173, 16, 29, 85)),
                          //   child: Center(
                          //     child: Text(
                          //       'Air Quality',
                          //       style: GoogleFonts.lato(
                          //         textStyle: TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 18,
                          //             letterSpacing: .5),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              // color: Colors.white,
                              color: const Color(0x00000099),
                              borderRadius: BorderRadius.circular(10),
                              // boxShadow: []],
                              border: Border.all(color: Colors.grey.shade500)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Lottie.asset('assets/clouds.json',
                              //     height: 240,
                              //     width: 200,
                              //     fit: BoxFit.cover,
                              //     animate: true,
                              //     alignment: AlignmentDirectional.center),
                              Image.network(
                                  "https://openweathermap.org/img/wn/10d@4x.png",
                                  // ${weatherInfo.weatherdata!.weather[0].icon}
                                  height: 240,
                                  width: 200,
                                  fit: BoxFit.cover,
                                  alignment: AlignmentDirectional.center),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${convertToFahrenheit(weatherInfo.weatherdata!.main.temp)}\u00B0",
                                    style: TextStyle(fontSize: 40),
                                  ),
                                  Text(
                                    formatDescName(weatherInfo
                                        .weatherdata!.weather[0].description),
                                    style: TextStyle(fontSize: 20),
                                    // softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 250,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                // color: Colors.white,
                                color: const Color(0x00000099),
                                // borderRadius: BorderRadius.circular(10),
                                // boxShadow: []],
                                border:
                                    Border.all(color: Colors.grey.shade500)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        CurrentData(
                                            weatherInfo: weatherInfo,
                                            weatherIcon: QWeatherIcons
                                                .tag_low_humidity2.iconData,
                                            title: "Humidity",
                                            value:
                                                "${weatherInfo.weatherdata!.main.humidity!.toDouble()}%"),
                                        CurrentData(
                                            weatherInfo: weatherInfo,
                                            weatherIcon: QWeatherIcons
                                                .tag_wind3.iconData,
                                            title: "Wind",
                                            value:
                                                "${weatherInfo.weatherdata!.wind.speed} km/h"),
                                        CurrentData(
                                            weatherInfo: weatherInfo,
                                            weatherIcon: QWeatherIcons
                                                .tag_sunny.iconData,
                                            title: "Sunrise",
                                            value:
                                                "${formatDate2(timeZoneToTime(weatherInfo.weatherdata!.sys.sunrise))} AM"),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        CurrentData(
                                            weatherInfo: weatherInfo,
                                            weatherIcon: QWeatherIcons
                                                .tag_high_temperature.iconData,
                                            title: "Feels like",
                                            value:
                                                "${convertToFahrenheit(weatherInfo.weatherdata!.main.feelsLike)}\u00B0C"),
                                        CurrentData(
                                            weatherInfo: weatherInfo,
                                            weatherIcon:
                                                QWeatherIcons.tag_wind.iconData,
                                            title: "Visibility",
                                            value:
                                                "${metersToKilometers(weatherInfo.weatherdata!.visibility)} km"),
                                        CurrentData(
                                            weatherInfo: weatherInfo,
                                            weatherIcon: QWeatherIcons
                                                .tag_full_moon.iconData,
                                            title: "Sunset",
                                            value:
                                                "${formatDate2(timeZoneToTime(weatherInfo.weatherdata!.sys.sunset))} PM"),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )))
                  ],
                ),
              ),
      ),
    );
  }
}


// Text(
//                       "${weatherInfo.weatherdata!.main.temp.toString()}\u00B0\n",
//                       style: TextStyle(fontSize: 40),
//                     ),
//                     Text(
//                       "${weatherInfo.weatherdata!.weather[0].main}\u00B0",
//                       style: TextStyle(fontSize: 30),
//                     ),