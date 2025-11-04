import 'package:equatable/equatable.dart';
import '../../../core/models/local_preference_model.dart';

/// Base state class for preference operations
abstract class PreferenceState extends Equatable {
  const PreferenceState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PreferenceInitial extends PreferenceState {
  const PreferenceInitial();
}

/// Loading state
class PreferenceLoading extends PreferenceState {
  const PreferenceLoading();
}

/// Success state with preferences list
class PreferenceSuccess extends PreferenceState {
  final List<LocalPreferenceModel> preferences;

  const PreferenceSuccess({required this.preferences});

  @override
  List<Object?> get props => [preferences];
}

/// Success state for single preference
class PreferenceDetailSuccess extends PreferenceState {
  final LocalPreferenceModel preference;

  const PreferenceDetailSuccess({required this.preference});

  @override
  List<Object?> get props => [preference];
}

/// Error state with message
class PreferenceError extends PreferenceState {
  final String message;

  const PreferenceError({required this.message});

  @override
  List<Object?> get props => [message];
}

