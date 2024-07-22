import 'dart:convert';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/API_KEY.dart';

Future<WeatherModel> fetchWeatherData(double lat, double lon) async {
  final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$API_KEY'));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return WeatherModel.fromJson(body);
  } else {
    throw Exception("Error fetching data");
  }
}
