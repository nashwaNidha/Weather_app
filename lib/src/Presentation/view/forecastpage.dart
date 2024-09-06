import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/src/Presentation/core/widget/custom_background.dart';
import 'package:weather_app/src/Presentation/core/widget/custom_button.dart';
import 'package:weather_app/src/Presentation/core/widget/location_text.dart';
import 'package:weather_app/src/providers/forecastprovider.dart';
import 'package:weather_app/src/providers/weatherprovider.dart';

import '../../model/forecast_weather_model.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<WeatherDetails>(context, listen: false).fetchData();
    Provider.of<ForecastDetails>(context, listen: false).fetchForecast();
  }

//conver fahrenheit to celcius
  int convertToFahrenheit(double fahrenheit) {
    return ((fahrenheit - 32) * 5 / 9).round().toInt();
  }

//To convert MillisecondsSinceEpoch to DateTime
  DateTime? unpackDate(dynamic k) {
    int millis = k * 1000;
    return DateTime.fromMillisecondsSinceEpoch(millis);
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

  String formatDateTime(DateTime dateTime) {
    // Format the date with day on the first line and abbreviated month, date on the second line
    final formattedDate =
        '${DateFormat('EEEE').format(dateTime)}\n${DateFormat('MMM d').format(dateTime)}';
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    final forecastInfo = Provider.of<ForecastDetails>(context);
    final weatherInfo = Provider.of<WeatherDetails>(context);
    return CustomBackground(
      child: Scaffold(
        backgroundColor: const Color(0x00000000),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: weatherInfo.isLoading == true && forecastInfo.isLoading == true
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
                    // Text(
                    //   formatDate2(
                    //       timeZoneToTime(weatherInfo.weatherdata!.timezone)),
                    //   style: GoogleFonts.lato(
                    //     textStyle:
                    //         const TextStyle(fontSize: 35, letterSpacing: .5),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                        title: 'weather',
                        onTap: () {
                          Navigator.of(context).pop();
                        }),
                    // Container(
                    //     height: 250,
                    //     decoration: BoxDecoration(
                    //       color: const Color(0x00000099),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: Lottie.asset('assets/sunny.json')),
                    // Padding(
                    //   padding: EdgeInsets.all(15.0),
                    //   child: SizedBox(
                    //     height: 50,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       children: [
                    //         Column(
                    //           children: [
                    //             Text("Temp"),
                    //             Text(
                    //               "${weatherInfo.weatherdata!.main!.temp!}\u00B0C",
                    //               style: TextStyle(fontSize: 13),
                    //             )
                    //           ],
                    //         ),
                    //         Column(
                    //           children: [Text("Wind"), Text("10Km/h")],
                    //         ),
                    //         Column(
                    //           children: [Text("Humidity"), Text("75%")],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Today's forecast",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    Consumer<ForecastDetails>(
                      builder: (context, value, child) {
                        DateTime currentDate = DateTime.now();

                        List<ListElement> forecastData =
                            value.forecastdata!.list;

                        List<ListElement> currentDayForecast = forecastData
                            .where((forecast) =>
                                forecast.dtTxt.year == currentDate.year &&
                                forecast.dtTxt.month == currentDate.month &&
                                forecast.dtTxt.day == currentDate.day)
                            .toList();

                        return SizedBox(
                          height: 90,
                          child: value.forecastdata == null
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: currentDayForecast.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 80,
                                        width: 140,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color.fromARGB(
                                                172, 143, 149, 180)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              width: 60,
                                              child: Image.network(
                                                "https://openweathermap.org/img/wn/${currentDayForecast[index].weather[0].icon}@2x.png",
                                                height: 70,
                                                width: 35,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  formatDate2(
                                                      currentDayForecast[index]
                                                          .dtTxt)
                                                  //  currentDayForecast[
                                                  //     index]
                                                  // .dtTxt
                                                  // .toString()
                                                  //
                                                  ,
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  "${convertToFahrenheit(currentDayForecast[index].main.temp)} \u00B0C",
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 80,
                      child: Text(
                        "6 days Forecast",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<ForecastDetails>(
                          builder: (context, value, child) {
                        List<ListElement> forecastData =
                            value.forecastdata!.list;
                        // day by day forecast
                        Map<String, List<ListElement>> groupForecastByDay(
                            List<ListElement> forecastData) {
                          Map<String, List<ListElement>> groupedData = {};
                          for (var element in forecastData) {
                            String date =
                                "${element.dtTxt.year}-${element.dtTxt.month}-${element.dtTxt.day}";

                            if (!groupedData.containsKey(date)) {
                              groupedData[date] = [];
                            }

                            groupedData[date]!.add(element);
                          }

                          return groupedData;
                        }

                        Map<String, List<ListElement>> groupedData =
                            groupForecastByDay(forecastData);

                        return SizedBox(
                          height: 350,
                          child: value.forecastdata == null
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              :

                              // child: SizedBox(
                              //   height: 250,

                              //   child:
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 5,

                                  // scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    String date =
                                        groupedData.keys.elementAt(index);
                                    List<ListElement> dailyData =
                                        groupedData[date]!;
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 80,
                                        width: 140,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color.fromARGB(
                                              172, 190, 195, 219),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            // Column(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.spaceEvenly,
                                            //   children: [
                                            //     Text(
                                            //       "Friday",
                                            //       style: TextStyle(fontSize: 15),
                                            //     ),
                                            //     Text("May,28",
                                            //         style: TextStyle(
                                            //           fontSize: 15,
                                            //         ))
                                            //   ],
                                            // ),
                                            Text(formatDateTime(
                                                unpackDate(dailyData[index].dt)
                                                    as DateTime)),
                                            Row(
                                              children: [
                                                Text(
                                                    "${convertToFahrenheit(dailyData[index].main.tempMin)} \u00B0C",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                    )),
                                                Text(
                                                    " \\ ${convertToFahrenheit(dailyData[index].main.tempMax)} \u00B0C",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                    )),
                                              ],
                                            ),
                                            Image.network(
                                              "https://openweathermap.org/img/wn/${dailyData[index].weather[0].icon}@2x.png",
                                              height: 70,
                                              width: 35,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
