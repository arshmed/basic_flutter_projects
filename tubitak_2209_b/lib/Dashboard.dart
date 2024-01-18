// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tubitak_2209_b/AzureApiService.dart';
import 'package:tubitak_2209_b/WeatherAPIService.dart';
import 'package:tubitak_2209_b/weather_data.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<WeatherData> _weatherData;
  late String _assignments = '';

  void updateAssignments(String assignments) {
    setState(() {
      _assignments = assignments;
    });
  }

  @override
  void initState() {
    super.initState();
    _weatherData = WeatherApiService(
            apiUrl:
                'https://archive-api.open-meteo.com/v1/archive?latitude=37.8713&longitude=32.4846&start_date=2019-01-01&end_date=2019-01-02&hourly=temperature_2m,relativehumidity_2m,apparent_temperature,rain,snowfall,cloudcover,cloudcover_low,cloudcover_high,windspeed_10m&daily=sunrise,sunset,windspeed_10m_max&timezone=auto')
        .fetchWeatherData();

    _weatherData.then((weatherData) {
      AzurAPIService(
        apiUrl:
            'https://ussouthcentral.services.azureml.net/workspaces/b26cb092f3a94b1baad8f798440318bc/services/cb469bb8cc204370927bd354b546d9e2/execute?api-version=2.0&details=true',
        azureMLApiKey:
            'YzrwdpIyQdvmXnuO1ie0KpVhxfzIasWk+A4HAgZiKY0zKmm38++OtsId/ngKGHIveVAeAA1a5g2t+AMCUKnbCg==',
        onUpdateAssignments: (assignments) {
          setState(() {
            _assignments = assignments;
          });
        },
      )
          .makeAzureMLApiCall(weatherData)
          .then((assignments) {})
          .catchError((error) {
        print('Error during Azure ML API call: $error');
      });
    });
  }

  String getMessageForAssignments(String assignments) {
    return assignments == '1' ? 'Sulama İçin Uygun' : 'Sulama İçin Uygun Değil';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff708D81),
        title: Text("Kontrol Paneli"),
      ),
      body: Center(
        child: FutureBuilder<WeatherData>(
          future: Future.delayed(Duration(seconds: 4), () => _weatherData),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 45),
                  Text(
                    'Veriler çekiliyor, makine öğrenmesi modeli çalışıyor...',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xff001427),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              WeatherData weatherData = snapshot.data!;
              return Container(
                margin: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WeatherInfoRow('Sıcaklık', '${weatherData.temperature} °C'),
                    WeatherInfoRow(
                        'Bağıl Nem', '${weatherData.relativeHumidity} %'),
                    WeatherInfoRow('Hissedilen Sıcaklık',
                        '${weatherData.apparentTemperature} °C'),
                    WeatherInfoRow('Yağış', '${weatherData.rain} mm'),
                    WeatherInfoRow('Kar Yağışı', '${weatherData.snowfall} mm'),
                    WeatherInfoRow('Bulutluluk Oranı (Ort.)',
                        '${weatherData.cloudCover} %'),
                    WeatherInfoRow('En Düşük Bulutluluk Oranı',
                        '${weatherData.cloudCoverLow} %'),
                    WeatherInfoRow('En Yüksek Bulutluluk Oranı',
                        '${weatherData.cloudCoverHigh} %'),
                    WeatherInfoRow(
                        'Rüzgar Hızı', '${weatherData.windSpeed} km/h'),
                    SizedBox(height: 66.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _assignments == '1'
                            ? Icon(Icons.check_circle,
                                color: Colors.green, size: 32.0)
                            : Icon(Icons.cancel, color: Colors.red, size: 32.0),
                        SizedBox(
                          width: 8.0,
                          height: 40,
                        ),
                        Text(
                          getMessageForAssignments(_assignments),
                          style: _assignments == '1'
                              ? TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)
                              : TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Text('No weather data available');
            }
          },
        ),
      ),
    );
  }
}

Widget WeatherInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue,
          ),
        ),
      ],
    ),
  );
}
