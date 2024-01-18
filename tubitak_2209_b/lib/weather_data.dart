// ignore_for_file: unused_local_variable

class WeatherData {
  final double temperature;
  final int relativeHumidity;
  final double apparentTemperature;
  final double rain;
  final double snowfall;
  final int cloudCover;
  final int cloudCoverLow;
  final int cloudCoverHigh;
  final double windSpeed;

  WeatherData({
    required this.temperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.rain,
    required this.snowfall,
    required this.cloudCover,
    required this.cloudCoverLow,
    required this.cloudCoverHigh,
    required this.windSpeed,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final hourlyData = json['hourly'];
    final dailyData = json['daily'];

    return WeatherData(
      temperature: hourlyData['temperature_2m'][0] + 35.toDouble(),
      relativeHumidity: hourlyData['relativehumidity_2m'][0].toInt(),
      apparentTemperature:
          hourlyData['apparent_temperature'][0] + 35.toDouble(),
      rain: hourlyData['rain'][0].toDouble(),
      snowfall: hourlyData['snowfall'][0].toDouble(),
      cloudCover: hourlyData['cloudcover'][0].toInt(),
      cloudCoverLow: hourlyData['cloudcover_low'][0].toInt(),
      cloudCoverHigh: hourlyData['cloudcover_high'][0].toInt(),
      windSpeed: hourlyData['windspeed_10m'][0].toDouble(),
    );
  }
}
