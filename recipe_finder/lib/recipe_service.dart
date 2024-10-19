import 'dart:convert';
import 'package:http/http.dart' as http;
import 'recipe.dart';

class RecipeService {
  static const String apiKey = 'f22c298d8c684d7fa3735f4eef3f9d51'; // Replace with your Spoonacular API key
  static const String apiUrl = 'https://api.spoonacular.com/recipes/findByIngredients';
  static const String randomRecipeUrl = 'https://api.spoonacular.com/recipes/random';

  // Fetch recipes based on ingredients
  Future<List<Recipe>> fetchRecipes(List<String> ingredients) async {
    final response = await http.get(Uri.parse('$apiUrl?ingredients=${ingredients.join(",")}&apiKey=$apiKey'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((recipe) => Recipe.fromJson(recipe)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  // Fetch a random recipe
  Future<Recipe> fetchRandomRecipe() async {
    final response = await http.get(Uri.parse('$randomRecipeUrl?apiKey=$apiKey'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Recipe.fromJson(jsonResponse['recipes'][0]);
    } else {
      throw Exception('Failed to load random recipe');
    }
  }
}
