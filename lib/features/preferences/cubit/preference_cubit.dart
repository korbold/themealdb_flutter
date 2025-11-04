import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repositories/preference_repository.dart';
import '../../../core/models/local_preference_model.dart';
import '../../../core/models/api_meal_model.dart';
import 'preference_state.dart';

/// Cubit for managing local preferences (CRUD operations)
class PreferenceCubit extends Cubit<PreferenceState> {
  final PreferenceRepository _repository;

  PreferenceCubit({PreferenceRepository? repository})
      : _repository = repository ?? PreferenceRepository(),
        super(const PreferenceInitial());

  /// Initializes the repository
  Future<void> init() async {
    await _repository.init();
    loadAllPreferences();
  }

  /// Loads all preferences
  void loadAllPreferences() {
    emit(const PreferenceLoading());
    try {
      final preferences = _repository.getAllPreferences();
      emit(PreferenceSuccess(preferences: preferences));
    } catch (e) {
      emit(PreferenceError(message: e.toString()));
    }
  }

  /// Loads a single preference by ID
  void loadPreferenceById(String id) {
    emit(const PreferenceLoading());
    try {
      final preference = _repository.getPreferenceById(id);
      if (preference != null) {
        emit(PreferenceDetailSuccess(preference: preference));
      } else {
        emit(const PreferenceError(message: 'Preference not found'));
      }
    } catch (e) {
      emit(PreferenceError(message: e.toString()));
    }
  }

  /// Creates a new preference from an API meal
  Future<void> createPreference({
    required String customName,
    required ApiMealModel apiMeal,
  }) async {
    emit(const PreferenceLoading());
    try {
      final preference = LocalPreferenceModel.fromApiMeal(
        customName: customName,
        apiMeal: apiMeal,
      );
      await _repository.createPreference(preference);
      loadAllPreferences();
    } catch (e) {
      emit(PreferenceError(message: e.toString()));
    }
  }

  /// Updates an existing preference
  Future<void> updatePreference(LocalPreferenceModel preference) async {
    emit(const PreferenceLoading());
    try {
      await _repository.updatePreference(preference);
      loadAllPreferences();
    } catch (e) {
      emit(PreferenceError(message: e.toString()));
    }
  }

  /// Deletes a preference by ID
  Future<void> deletePreference(String id) async {
    emit(const PreferenceLoading());
    try {
      await _repository.deletePreference(id);
      loadAllPreferences();
    } catch (e) {
      emit(PreferenceError(message: e.toString()));
    }
  }
}

