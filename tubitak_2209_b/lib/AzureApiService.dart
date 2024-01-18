import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tubitak_2209_b/weather_data.dart';

class AzurAPIService {
  final String apiUrl;
  final String azureMLApiKey;

  final Function(String) onUpdateAssignments;

  AzurAPIService(
      {required this.apiUrl,
        required this.azureMLApiKey,
        required this.onUpdateAssignments});

  Future<String> makeAzureMLApiCall(WeatherData weatherData) async {
    final Map<String, dynamic> inputData = {
      "Inputs": {
        "input1": {
          "ColumnNames": [
            "time",
            "temperature_2m (°C)",
            "relativehumidity_2m (%)",
            "apparent_temperature (°C)",
            "precipitation (mm)",
            "rain (mm)",
            "snowfall (cm)",
            "weathercode (wmo code)",
            "pressure_msl (hPa)",
            "cloudcover (%)",
            "cloudcover_low (%)",
            "cloudcover_high (%)",
            "windspeed_100m (km/h)",
            "soil_temperature_0_to_7cm (°C)",
            "soil_moisture_0_to_7cm (m³/m³)"
          ],
          "Values": [
            [
              "",
              weatherData.temperature.toString(),
              weatherData.relativeHumidity.toString(),
              weatherData.apparentTemperature.toString(),
              weatherData.rain.toString(),
              weatherData.snowfall.toString(),
              weatherData.cloudCover.toString(),
              weatherData.cloudCoverLow.toString(),
              weatherData.cloudCoverHigh.toString(),
              weatherData.windSpeed.toString(),
              "0", // Add other values as needed
              "0", // Add other values as needed
              "0", // Add other values as needed
              "0", // Add other values as needed
              "0" // Add other values as needed
            ],
            [
              "",
              "0",
              "0",
              "0",
              "0",
              "0",
              "0",
              "0",
              "0",
              "0",
              "0",
              "0",
              "0",
              "0",
              "0"
            ],
          ]
        }
      },
      "GlobalParameters": {}
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $azureMLApiKey',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(inputData),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final assignments = jsonResponse['Results']['output1']['value']
        ['Values'][0][15]; // Extracting "Assignments" value
        onUpdateAssignments(assignments.toString());
        return assignments.toString();
      } else {
        print(
            'Failed to make Azure ML API call. Status code: ${response.statusCode}');
        // Handle error here
        return 'Failed';
      }
    } catch (error) {
      print('Error occurred during API call: $error');
      return 'Error occurred during API call: $error';
    }
  }
}
