import 'dart:convert';

class Recipe {
  final String title;
  final String imageUrl;
  final List<String> ingredients;

  Recipe({
    required this.title,
    required this.imageUrl,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    if (json['missedIngredients'] != null) {
      json['missedIngredients'].forEach((ingredient) {
        ingredients.add(ingredient['name']);
      });
    }

    return Recipe(
      title: json['title'],
      imageUrl: json['image'] ?? '',
      ingredients: ingredients,
    );
  }

  // Method to convert Recipe to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
    };
  }

  // Method to create Recipe from JSON string
  static Recipe fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Recipe.fromJson(json);
  }

  // Method to convert Recipe to JSON string
  String toJsonString() {
    final Map<String, dynamic> json = toJson();
    return jsonEncode(json);
  }
}
