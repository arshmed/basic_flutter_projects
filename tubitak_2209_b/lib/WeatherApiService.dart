import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tubitak_2209_b/weather_data.dart';

class WeatherApiService {
  String apiUrl =
      "https://archive-api.open-meteo.com/v1/archive?latitude=37.8713&longitude=32.4846&start_date=2019-01-01&end_date=2019-01-01&hourly=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,rain,snowfall,weather_code,pressure_msl,surface_pressure,cloud_cover,cloud_cover_low,cloud_cover_mid,cloud_cover_high,wind_speed_10m,soil_temperature_0_to_7cm,soil_moisture_0_to_7cm&daily=weather_code,precipitation_sum,rain_sum,snowfall_sum,precipitation_hours,wind_speed_10m_max&timezone=auto";

  WeatherApiService({required this.apiUrl});

  Future<WeatherData> fetchWeatherData() async {
    final response = await http.get(Uri.parse(apiUrl));
    // print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      return WeatherData.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load weather data from the API');
    }
  }
}
