import 'package:hive_flutter/hive_flutter.dart';
import '../models/local_preference_model.dart';
import '../models/local_preference_model_adapter.dart';

/// Repository for managing local preferences (CRUD operations)
class PreferenceRepository {
  static const String _boxName = 'preferences';

  /// Initializes Hive and opens the preferences box
  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(LocalPreferenceModelAdapter());
    }
    await Hive.openBox<LocalPreferenceModel>(_boxName);
  }

  /// Gets the preferences box
  Box<LocalPreferenceModel> get _box => Hive.box<LocalPreferenceModel>(_boxName);

  /// Creates a new preference
  Future<void> createPreference(LocalPreferenceModel preference) async {
    await _box.put(preference.id, preference);
  }

  /// Gets all preferences
  List<LocalPreferenceModel> getAllPreferences() {
    return _box.values.toList();
  }

  /// Gets a preference by ID
  LocalPreferenceModel? getPreferenceById(String id) {
    try {
      if (!_box.isOpen) {
        throw Exception('Hive box is not open');
      }
      return _box.get(id);
    } catch (e) {
      throw Exception('Error getting preference: $e');
    }
  }

  /// Updates a preference
  Future<void> updatePreference(LocalPreferenceModel preference) async {
    await _box.put(preference.id, preference);
  }

  /// Deletes a preference by ID
  Future<void> deletePreference(String id) async {
    await _box.delete(id);
  }

  /// Deletes all preferences
  Future<void> deleteAllPreferences() async {
    await _box.clear();
  }
}

