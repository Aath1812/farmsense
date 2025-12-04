// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmsense/viewmodels/providers.dart';
import 'package:farmsense/models/weather_model.dart';

class WeatherCard extends ConsumerWidget {
  const WeatherCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsyncValue = ref.watch(weatherProvider);

    return weatherAsyncValue.when(
      data: (weather) => _buildWeatherCardContent(context, weather),
      loading: () => _buildLoadingCard(context),
      error: (err, stack) => _buildErrorCard(context, err.toString()),
    );
  }

  // Helper to get gradient based on weather condition
  LinearGradient _getGradient(String condition) {
    final normalizedCondition = condition.toLowerCase();

    if (normalizedCondition.contains('rain') || normalizedCondition.contains('drizzle')) {
      return const LinearGradient(
        colors: [Color(0xFF4A90E2), Color(0xFF002F6C)], // Rainy Blue
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (normalizedCondition.contains('clear') || normalizedCondition.contains('sun')) {
      return const LinearGradient(
        colors: [Color(0xFFFF9800), Color(0xFFF57C00)], // Sunny Orange
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (normalizedCondition.contains('cloud')) {
      return const LinearGradient(
        colors: [Color(0xFF78909C), Color(0xFF455A64)], // Cloudy Grey
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      // Default / Clear
      return const LinearGradient(
        colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)], // Farm Green default
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  Widget _buildWeatherCardContent(BuildContext context, WeatherModel weather) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: _getGradient(weather.condition), // Dynamic Gradient
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weather.city,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '${weather.temp.toStringAsFixed(1)}°C',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  weather.condition,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Image.network(
            'https://openweathermap.org/img/wn/${weather.iconCode}@2x.png',
            width: 80,
            height: 80,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.wb_sunny, color: Colors.white, size: 80);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 150,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Colors.green),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String errorMessage) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 150,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, color: Colors.grey, size: 40),
            const SizedBox(height: 8.0),
            const Text(
              'Weather unavailable offline',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}