import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/api_service.dart';
import 'api_state.dart';

/// Cubit for managing API data fetching operations
class ApiCubit extends Cubit<ApiState> {
  final ApiService _apiService;

  ApiCubit({ApiService? apiService})
      : _apiService = apiService ?? ApiService(),
        super(const ApiInitial());

  /// Searches for meals by query string
  Future<void> searchMeals(String query) async {
    if (query.trim().isEmpty) {
      emit(const ApiSuccess(meals: []));
      return;
    }

    emit(const ApiLoading());
    try {
      final meals = await _apiService.searchMeals(query);
      emit(ApiSuccess(meals: meals));
    } catch (e) {
      emit(ApiError(message: e.toString()));
    }
  }

  /// Gets a random meal
  Future<void> getRandomMeal() async {
    emit(const ApiLoading());
    try {
      final meal = await _apiService.getRandomMeal();
      if (meal != null) {
        emit(ApiSuccess(meals: [meal]));
      } else {
        emit(const ApiError(message: 'No meal found'));
      }
    } catch (e) {
      emit(ApiError(message: e.toString()));
    }
  }

  /// Resets to initial state
  void reset() {
    emit(const ApiInitial());
  }
}

