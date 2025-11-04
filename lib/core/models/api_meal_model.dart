import 'package:equatable/equatable.dart';

/// Model representing a meal from the API
class ApiMealModel extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;
  final String? category;
  final String? area;
  final String? instructions;

  const ApiMealModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.category,
    this.area,
    this.instructions,
  });

  /// Creates an ApiMealModel from JSON
  factory ApiMealModel.fromJson(Map<String, dynamic> json) {
    return ApiMealModel(
      id: json['idMeal'] as String? ?? '',
      name: json['strMeal'] as String? ?? '',
      imageUrl: json['strMealThumb'] as String?,
      category: json['strCategory'] as String?,
      area: json['strArea'] as String?,
      instructions: json['strInstructions'] as String?,
    );
  }

  /// Converts ApiMealModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': imageUrl,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
    };
  }

  @override
  List<Object?> get props => [id, name, imageUrl, category, area, instructions];
}

/// Response model for API search results
class ApiMealResponse {
  final List<ApiMealModel> meals;

  const ApiMealResponse({required this.meals});

  factory ApiMealResponse.fromJson(Map<String, dynamic> json) {
    final mealsList = json['meals'] as List<dynamic>?;
    if (mealsList == null) {
      return const ApiMealResponse(meals: []);
    }
    
    return ApiMealResponse(
      meals: mealsList
          .map((meal) => ApiMealModel.fromJson(meal as Map<String, dynamic>))
          .toList(),
    );
  }
}

