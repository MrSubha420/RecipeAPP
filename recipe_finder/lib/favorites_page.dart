import 'package:flutter/material.dart';
import 'recipe.dart';

class FavoritesPage extends StatelessWidget {
  final List<Recipe> favorites;

  FavoritesPage({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final recipe = favorites[index];
          return ListTile(
            leading: recipe.imageUrl.isNotEmpty
                ? Image.network(recipe.imageUrl, width: 100, height: 100)
                : Container(width: 100, height: 100),
            title: Text(recipe.title),
          );
        },
      ),
    );
  }
}
