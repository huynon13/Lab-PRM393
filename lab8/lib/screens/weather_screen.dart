import 'package:flutter/material.dart';

import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({
    super.key,
    this.weatherService,
  });

  final WeatherService? weatherService;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late final WeatherService _service;
  bool _ownService = false;

  final TextEditingController _controller = TextEditingController(text: 'Hanoi');
  Future<(LocationModel, WeatherModel)>? _future;

  @override
  void initState() {
    super.initState();
    if (widget.weatherService != null) {
      _service = widget.weatherService!;
      _ownService = false;
    } else {
      _service = WeatherService();
      _ownService = true;
    }
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_ownService) _service.close();
    super.dispose();
  }

  void _load() {
    final city = _controller.text.trim();
    if (city.isEmpty) return;
    setState(() {
      _future = _service.fetchWeatherForCity(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Companion')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _load(),
                    decoration: const InputDecoration(
                      labelText: 'Thành phố',
                      hintText: 'VD: Hanoi, Da Nang, Ho Chi Minh',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _load,
                  child: const Text('Tải'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<(LocationModel, WeatherModel)>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return _ErrorState(
                      message: snapshot.error.toString(),
                      onRetry: _load,
                    );
                  }

                  final data = snapshot.data;
                  if (data == null) {
                    return const Center(child: Text('No data'));
                  }

                  final location = data.$1;
                  final weather = data.$2;

                  return ListView(
                    children: [
                      _InfoCard(
                        title: location.displayName,
                        children: [
                          _kv('Nhiệt độ hiện tại', '${weather.temperatureC.toStringAsFixed(1)}°C'),
                          _kv('Gió', '${weather.windSpeedKmh.toStringAsFixed(1)} km/h'),
                          _kv(
                            'Xác suất mưa (max)',
                            weather.precipitationProbabilityMax == null
                                ? 'N/A'
                                : '${weather.precipitationProbabilityMax}%',
                          ),
                          _kv(
                            'Nhiệt độ (min/max)',
                            (weather.tempMinC == null || weather.tempMaxC == null)
                                ? 'N/A'
                                : '${weather.tempMinC!.toStringAsFixed(0)}°C / ${weather.tempMaxC!.toStringAsFixed(0)}°C',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _InfoCard(
                        title: 'Gợi ý cho bạn',
                        children: [
                          Text(
                            weather.shortRecommendation,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _InfoCard(
                        title: 'Mục đích (Lab 8B)',
                        children: const [
                          Text(
                            'Ứng dụng giúp quyết định nhanh: hôm nay có cần mang ô/áo mưa không.',
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(child: Text(k)),
          const SizedBox(width: 12),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Something went wrong',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

