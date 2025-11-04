import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repositories/preference_repository.dart';
import '../../../core/models/local_preference_model.dart';
import '../../../core/models/api_meal_model.dart';
import 'preference_state.dart';

/// Cubit para gestionar la lista de gustos (CRUD)
class PreferenceListCubit extends Cubit<PreferenceState> {
  final PreferenceRepository _repository;

  PreferenceListCubit({PreferenceRepository? repository})
      : _repository = repository ?? PreferenceRepository(),
        super(const PreferenceInitial());

  Future<void> init() async {
    await _repository.init();
    loadAllPreferences();
  }

  void loadAllPreferences() {
    emit(const PreferenceLoading());
    try {
      final preferences = _repository.getAllPreferences();
      emit(PreferenceSuccess(preferences: preferences));
    } catch (e) {
      emit(PreferenceError(message: e.toString()));
    }
  }

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

  Future<void> updatePreference(LocalPreferenceModel preference) async {
    emit(const PreferenceLoading());
    try {
      await _repository.updatePreference(preference);
      loadAllPreferences();
    } catch (e) {
      emit(PreferenceError(message: e.toString()));
    }
  }

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
