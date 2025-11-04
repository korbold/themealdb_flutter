import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repositories/preference_repository.dart';
import 'preference_state.dart';

/// Cubit para gestionar el detalle de un gusto (solo lectura por id)
class PreferenceDetailCubit extends Cubit<PreferenceState> {
  final PreferenceRepository _repository;

  PreferenceDetailCubit({PreferenceRepository? repository})
      : _repository = repository ?? PreferenceRepository(),
        super(const PreferenceInitial());

  Future<void> loadPreferenceById(String id) async {
    emit(const PreferenceLoading());
    try {
      // Nos aseguramos de que el repositorio esté inicializado
      await _repository.init();
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
}
