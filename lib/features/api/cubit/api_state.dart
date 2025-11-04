import 'package:equatable/equatable.dart';
import '../../../core/models/api_meal_model.dart';

/// Base state class for API operations
abstract class ApiState extends Equatable {
  const ApiState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ApiInitial extends ApiState {
  const ApiInitial();
}

/// Loading state
class ApiLoading extends ApiState {
  const ApiLoading();
}

/// Success state with meals data
class ApiSuccess extends ApiState {
  final List<ApiMealModel> meals;

  const ApiSuccess({required this.meals});

  @override
  List<Object?> get props => [meals];
}

/// Error state with message
class ApiError extends ApiState {
  final String message;

  const ApiError({required this.message});

  @override
  List<Object?> get props => [message];
}

