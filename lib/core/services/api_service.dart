import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_meal_model.dart';

/// Service for interacting with TheMealDB API
class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  /// Searches for meals by name
  Future<List<ApiMealModel>> searchMeals(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search.php?s=$query'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final apiResponse = ApiMealResponse.fromJson(jsonData);
        return apiResponse.meals;
      } else {
        throw Exception('Failed to load meals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching meals: $e');
    }
  }

  /// Gets a random meal
  Future<ApiMealModel?> getRandomMeal() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/random.php'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final apiResponse = ApiMealResponse.fromJson(jsonData);
        return apiResponse.meals.isNotEmpty ? apiResponse.meals.first : null;
      } else {
        throw Exception('Failed to load random meal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting random meal: $e');
    }
  }

  /// Gets meal by ID
  Future<ApiMealModel?> getMealById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/lookup.php?i=$id'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final apiResponse = ApiMealResponse.fromJson(jsonData);
        return apiResponse.meals.isNotEmpty ? apiResponse.meals.first : null;
      } else {
        throw Exception('Failed to load meal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting meal by ID: $e');
    }
  }
}

