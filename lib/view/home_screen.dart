import 'package:flutter/material.dart';
import 'package:weather_app/colors/colors.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/view_model/weather_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<WeatherModel>? weatherData;
  String selectedLocation = '';
  double lat = 33.70;
  double lon = 73.03;

  @override
  void initState() {
    super.initState();
    weatherData = fetchWeatherData(lat, lon);
  }

  void updateLocation(String location) {
    switch (location) {
      case 'MELBOURNE':
        lat = -37.81;
        lon = 144.94;
        break;
      case 'LONDON':
        lat = 51.5074;
        lon = -0.1278;
        break;
      case 'PARIS':
        lat = 48.8566;
        lon = 2.3522;
        break;
      case 'TOKYO':
        lat = 35.6895;
        lon = 139.6917;
        break;
      case 'BEIJING':
        lat = 39.9042;
        lon = 116.4074;
        break;
      default:
        lat = 33.70;
        lon = 73.03;
    }

    setState(() {
      selectedLocation = location;
      weatherData = fetchWeatherData(lat, lon);
    });
  }

  @override
  Widget build(BuildContext context) {
    var sunImage = 'assets/sun.webp';
    var cloudsImage = 'assets/clouds.webp';
    var nightCloudsImage = 'assets/night_clouds.png';
    var stormImage = 'assets/storm.png';
    var windImage = 'assets/wind.png';
    var rainingImage = 'assets/raining.png';
    var snowyImage = 'assets/snowy.jpg';
    var moonImage = 'assets/moon.webp';

    return Scaffold(
      body: FutureBuilder<WeatherModel>(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: splashColor,
              child: const Center(
                child: CircularProgressIndicator(
                  color: whiteColor,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var weatherCondition = snapshot.data!.weather![0].main.toString();
            double? temperature = snapshot.data!.main!.temp! - 273;
            double? feelsLike = snapshot.data!.main!.feelsLike! - 273;

            return Container(
              color: DateTime.now().hour >= 19 || DateTime.now().hour <= 5
                  ? nightColor
                  : weatherCondition == "Clouds"
                      ? cloudyColor
                      : weatherCondition == "Clear"
                          ? sunnyColor
                          : weatherCondition == "Storm"
                              ? stormColor
                              : weatherCondition == "Snowy"
                                  ? snowyColor
                                  : weatherCondition == "Windy"
                                      ? windyColor
                                      : weatherCondition == "Rain"
                                          ? rainyColor
                                          : splashColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 70),
                    Row(
                      children: [
                        Text(
                          "${snapshot.data!.name.toString().toUpperCase()}, ${snapshot.data!.sys!.country.toString().toUpperCase()}",
                          style: const TextStyle(
                            fontSize: 26,
                            color: whiteColor,
                            letterSpacing: 5,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.location_on,
                          color: whiteColor,
                          size: 26,
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            showMenu(
                              context: context,
                              position:
                                  const RelativeRect.fromLTRB(100, 100, 0, 0),
                              items: <PopupMenuEntry>[
                                const PopupMenuItem(
                                    value: 'MELBOURNE',
                                    child: Text('MELBOURNE')),
                                const PopupMenuItem(
                                  value: 'LONDON',
                                  child: Text('LONDON'),
                                ),
                                const PopupMenuItem(
                                  value: 'PARIS',
                                  child: Text('PARIS'),
                                ),
                                const PopupMenuItem(
                                  value: 'TOKYO',
                                  child: Text('TOKYO'),
                                ),
                                const PopupMenuItem(
                                  value: 'BEIJING',
                                  child: Text('BEIJING'),
                                ),
                              ],
                            ).then((value) {
                              if (value != null) {
                                updateLocation(value);
                              }
                            });
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 24,
                            color: whiteColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 95,
                      child: Row(
                        children: [
                          Text(
                            "${temperature.toStringAsFixed(0)}\u00B0",
                            style: const TextStyle(
                              fontSize: 85,
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              snapshot.data!.weather![0].main
                                  .toString()
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: whiteColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          const SizedBox(width: 30),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "${DateTime.now().day.toString()}/${DateTime.now().month.toString()}/${DateTime.now().year.toString()}",
                              style: const TextStyle(
                                color: whiteColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: Image.asset(
                        (weatherCondition == "Clouds" &&
                                (DateTime.now().hour >= 19 ||
                                    DateTime.now().hour <= 5))
                            ? nightCloudsImage
                            : (weatherCondition == "Clear" &&
                                    (DateTime.now().hour >= 19 ||
                                        DateTime.now().hour <= 5))
                                ? moonImage
                                : weatherCondition == "Clouds"
                                    ? cloudsImage
                                    : weatherCondition == "Rain"
                                        ? rainingImage
                                        : weatherCondition == "Clear"
                                            ? sunImage
                                            : weatherCondition == "Storm"
                                                ? stormImage
                                                : weatherCondition == "Snowy"
                                                    ? snowyImage
                                                    : weatherCondition ==
                                                            "Windy"
                                                        ? windImage
                                                        : sunImage,
                        width: 200,
                        height: 200,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: whiteColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.cloud_outlined,
                              color: whiteColor,
                            ),
                            title: const Text(
                              'Feels Like',
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                            trailing: Text(
                              "${feelsLike.toStringAsFixed(0)}\u00B0",
                              style: const TextStyle(
                                fontSize: 18,
                                color: whiteColor,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.water_drop_outlined,
                              color: whiteColor,
                            ),
                            title: const Text(
                              'Humidity',
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                            trailing: Text(
                              snapshot.data!.main!.humidity.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: whiteColor,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.air,
                              color: whiteColor,
                            ),
                            title: const Text(
                              'Wind Speed',
                              style: TextStyle(color: whiteColor),
                            ),
                            trailing: Text(
                              "${snapshot.data!.wind!.speed.toString()}m/s",
                              style: const TextStyle(
                                fontSize: 18,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 45),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
