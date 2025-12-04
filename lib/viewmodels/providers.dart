import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:farmsense/models/weather_model.dart';
import 'package:farmsense/models/crop_log.dart';
import 'package:farmsense/repositories/weather_repository.dart';
import 'package:farmsense/repositories/crop_repository.dart';

// 1. Weather Repository Provider
final weatherRepositoryProvider = Provider((ref) => WeatherRepository());

// 2. Crop Database Box Provider
final cropBoxProvider = Provider<Box<CropLog>>((ref) => Hive.box<CropLog>('cropLogs'));

// 3. Crop Repository Provider
final cropRepositoryProvider = Provider((ref) {
  final box = ref.watch(cropBoxProvider);
  return CropRepository(box);
});

// 4. Weather Data Provider (Dynamic based on User Profile)
final weatherProvider = FutureProvider<WeatherModel>((ref) async {
  final repo = ref.watch(weatherRepositoryProvider);

  // Watch the user profile to get the farm location
  final userProfile = ref.watch(userProfileProvider);

  // Get the location entered by the farmer, or default to 'Pune' if empty
  String city = userProfile['location'] ?? 'Pune';

  // Simple check to ensure we don't send an empty string
  if (city.trim().isEmpty) city = 'Pune';

  return await repo.fetchWeather(city);
});

// 5. Crop List Logic (StateNotifier)
class CropListNotifier extends StateNotifier<List<CropLog>> {
  final CropRepository _repository;

  CropListNotifier(this._repository) : super(_repository.getAllCropLogs());

  Future<void> addCropLog(CropLog log) async {
    await _repository.addCropLog(log);
    state = _repository.getAllCropLogs(); // Refresh UI
  }

  Future<void> updateCropLog(CropLog log) async {
    await _repository.updateCropLog(log);
    state = _repository.getAllCropLogs(); // Refresh UI
  }

  Future<void> deleteCropLog(String id) async {
    await _repository.deleteCropLog(id);
    state = _repository.getAllCropLogs(); // Refresh UI
  }
}

// 6. Crop List Provider (The one the UI watches)
final cropListProvider = StateNotifierProvider<CropListNotifier, List<CropLog>>((ref) {
  final repo = ref.watch(cropRepositoryProvider);
  return CropListNotifier(repo);
});

// 7. User Profile Provider
class UserProfileNotifier extends StateNotifier<Map<String, String>> {
  UserProfileNotifier() : super({
    'name': 'Atharva',
    'mobile': '9876543210',
    'location': 'Pune District',
    'age': '18-25',
    'gender': 'Male',
    'education': 'Graduate',
    'land_size': '5',
    'land_unit': 'Acres',
    'soil': 'Black (Kali)',
    'irrigation': 'Well',
  });

  // Updated to accept a Map for flexibility
  void updateProfileMap(Map<String, String> newProfileData) {
    state = {...state, ...newProfileData};
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, Map<String, String>>((ref) {
  return UserProfileNotifier();
});