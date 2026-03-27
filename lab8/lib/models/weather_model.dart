class WeatherModel {
  final double temperatureC;
  final double windSpeedKmh;
  final int weatherCode;

  /// Dữ liệu theo ngày (hôm nay).
  final int? precipitationProbabilityMax; // %
  final double? tempMaxC;
  final double? tempMinC;

  const WeatherModel({
    required this.temperatureC,
    required this.windSpeedKmh,
    required this.weatherCode,
    this.precipitationProbabilityMax,
    this.tempMaxC,
    this.tempMinC,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = (json['current'] as Map?)?.cast<String, dynamic>() ?? const {};
    final daily = (json['daily'] as Map?)?.cast<String, dynamic>() ?? const {};

    int? firstInt(String key) {
      final v = daily[key];
      if (v is List && v.isNotEmpty) return (v.first as num).toInt();
      return null;
    }

    double? firstDouble(String key) {
      final v = daily[key];
      if (v is List && v.isNotEmpty) return (v.first as num).toDouble();
      return null;
    }

    return WeatherModel(
      temperatureC: (current['temperature_2m'] as num).toDouble(),
      windSpeedKmh: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      precipitationProbabilityMax: firstInt('precipitation_probability_max'),
      tempMaxC: firstDouble('temperature_2m_max'),
      tempMinC: firstDouble('temperature_2m_min'),
    );
  }

  /// Gợi ý “có cần mang ô không?” dựa trên % mưa cao nhất trong ngày.
  bool get shouldBringUmbrella {
    final p = precipitationProbabilityMax;
    if (p == null) return false;
    return p >= 40;
  }

  String get shortRecommendation {
    if (shouldBringUmbrella) return 'Nên mang ô/áo mưa (nguy cơ mưa cao).';
    return 'Khả năng mưa thấp, không cần mang ô.';
  }
}

