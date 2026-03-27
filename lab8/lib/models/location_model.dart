class LocationModel {
  final String name;
  final String? admin1;
  final String? country;
  final double latitude;
  final double longitude;

  const LocationModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.admin1,
    this.country,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: (json['name'] ?? '').toString(),
      admin1: json['admin1']?.toString(),
      country: json['country']?.toString(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  String get displayName {
    final parts = <String>[
      name,
      if (admin1 != null && admin1!.trim().isNotEmpty) admin1!.trim(),
      if (country != null && country!.trim().isNotEmpty) country!.trim(),
    ];
    return parts.join(', ');
  }
}

