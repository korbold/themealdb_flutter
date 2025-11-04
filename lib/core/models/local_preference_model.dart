import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'api_meal_model.dart';

/// Model representing a saved preference (local storage)
@HiveType(typeId: 0)
class LocalPreferenceModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String customName;

  @HiveField(2)
  final String apiMealId;

  @HiveField(3)
  final String apiMealName;

  @HiveField(4)
  final String? imageUrl;

  @HiveField(5)
  final String? category;

  @HiveField(6)
  final String? area;

  @HiveField(7)
  final String? instructions;

  @HiveField(8)
  final DateTime createdAt;

  const LocalPreferenceModel({
    required this.id,
    required this.customName,
    required this.apiMealId,
    required this.apiMealName,
    this.imageUrl,
    this.category,
    this.area,
    this.instructions,
    required this.createdAt,
  });

  /// Creates a LocalPreferenceModel from an ApiMealModel
  factory LocalPreferenceModel.fromApiMeal({
    required String customName,
    required ApiMealModel apiMeal,
  }) {
    return LocalPreferenceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customName: customName,
      apiMealId: apiMeal.id,
      apiMealName: apiMeal.name,
      imageUrl: apiMeal.imageUrl,
      category: apiMeal.category,
      area: apiMeal.area,
      instructions: apiMeal.instructions,
      createdAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        customName,
        apiMealId,
        apiMealName,
        imageUrl,
        category,
        area,
        instructions,
        createdAt,
      ];
}

