import 'package:hive_flutter/hive_flutter.dart';
import 'package:farmsense/models/crop_log.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

class CropRepository {
  final Box<CropLog> _cropBox;
  final Uuid _uuid = const Uuid();

  CropRepository(this._cropBox);

  Future<void> addCropLog(CropLog log) async {
    log.id = _uuid.v4(); // Assign a unique ID
    await _cropBox.put(log.id, log);
  }

  Future<void> updateCropLog(CropLog log) async {
    // Ensure the log has an ID before updating
    if (log.id.isNotEmpty) {
      await _cropBox.put(log.id, log);
    } else {
      debugPrint('Error: Cannot update CropLog without an ID.');
    }
  }

  Future<void> deleteCropLog(String id) async {
    await _cropBox.delete(id);
  }

  List<CropLog> getAllCropLogs() {
    return _cropBox.values.toList().cast<CropLog>();
  }

  Future<void> initMockData() async {
    if (_cropBox.isEmpty) {
      final mockLogs = [
        CropLog(
          id: '', // Will be replaced by addCropLog
          cropType: 'Wheat',
          date: DateTime.now().subtract(const Duration(days: 30)),
          notes: 'Preparing for harvest.',
          status: 'Growing',
          yieldAmount: 0.0,
        ),
        CropLog(
          id: '', // Will be replaced by addCropLog
          cropType: 'Corn',
          date: DateTime.now().subtract(const Duration(days: 60)),
          notes: 'Harvested last week.',
          status: 'Harvested',
          yieldAmount: 500.0,
        ),
        CropLog(
          id: '', // Will be replaced by addCropLog
          cropType: 'Soybeans',
          date: DateTime.now().subtract(const Duration(days: 15)),
          notes: 'Newly sown crop.',
          status: 'Sown',
          yieldAmount: 0.0,
        ),
        // Adding more random crop data
        CropLog(
          id: '',
          cropType: 'Rice',
          date: DateTime.now().subtract(const Duration(days: 90)),
          notes: 'Flooded fields, good growth.',
          status: 'Growing',
          yieldAmount: 0.0,
        ),
        CropLog(
          id: '',
          cropType: 'Potatoes',
          date: DateTime.now().subtract(const Duration(days: 45)),
          notes: 'Pest control applied.',
          status: 'Growing',
          yieldAmount: 0.0,
        ),
        CropLog(
          id: '',
          cropType: 'Tomatoes',
          date: DateTime.now().subtract(const Duration(days: 7)),
          notes: 'First fruits appearing.',
          status: 'Sown', // Sown recently, moving to growing
          yieldAmount: 0.0,
        ),
        CropLog(
          id: '',
          cropType: 'Barley',
          date: DateTime.now().subtract(const Duration(days: 120)),
          notes: 'Successfully harvested and stored.',
          status: 'Harvested',
          yieldAmount: 300.0,
        ),
        CropLog(
          id: '',
          cropType: 'Wheat',
          date: DateTime.now().subtract(const Duration(days: 10)),
          notes: 'Another wheat field.',
          status: 'Sown',
          yieldAmount: 0.0,
        ),
        CropLog(
          id: '',
          cropType: 'Corn',
          date: DateTime.now().subtract(const Duration(days: 20)),
          notes: 'Another corn field.',
          status: 'Growing',
          yieldAmount: 0.0,
        ),
        CropLog(
          id: '',
          cropType: 'Soybeans',
          date: DateTime.now().subtract(const Duration(days: 40)),
          notes: 'Another soybeans field.',
          status: 'Harvested',
          yieldAmount: 400.0,
        ),
      ];

      for (var log in mockLogs) {
        await addCropLog(log);
      }
      debugPrint('Mock crop data initialized.');
    }
  }
}
