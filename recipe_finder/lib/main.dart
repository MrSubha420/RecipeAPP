import 'package:flutter/material.dart';
import 'recipe.dart';
import 'recipe_service.dart';
import 'recipe_detail_page.dart';
import 'favorites_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import Shared Preferences

void main() {
  runApp(RecipeFinderApp());
}

class RecipeFinderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Finder',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: RecipeHomePage(),
    );
  }
}

class RecipeHomePage extends StatefulWidget {
  @override
  _RecipeHomePageState createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {
  final TextEditingController _controller = TextEditingController();
  final RecipeService _recipeService = RecipeService();
  List<Recipe> _recipes = [];
  List<Recipe> _favorites = [];
  bool _loading = false;
  Recipe? _randomRecipe;

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Load favorites when the app starts
  }

  // Load favorites from local storage
  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteJsons = prefs.getStringList('favorites');
    if (favoriteJsons != null) {
      setState(() {
        _favorites = favoriteJsons.map((json) => Recipe.fromJsonString(json)).toList();
      });
    }
  }

  // Fetch recipes based on user input
  void _searchRecipes() async {
    setState(() {
      _loading = true;
      _randomRecipe = null; // Clear random recipe when searching
    });

    final ingredients = _controller.text.split(',').map((e) => e.trim()).toList();

    try {
      final recipes = await _recipeService.fetchRecipes(ingredients);
      setState(() {
        _recipes = recipes;
      });
    } catch (e) {
      // Handle errors
      print('Error fetching recipes: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  // Fetch a random recipe
  void _getRandomRecipe() async {
    setState(() {
      _loading = true;
      _recipes = []; // Clear search results when getting a random recipe
    });

    try {
      final recipe = await _recipeService.fetchRandomRecipe();
      setState(() {
        _randomRecipe = recipe;
      });
    } catch (e) {
      // Handle errors
      print('Error fetching random recipe: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  // Add or remove a recipe from favorites and save to local storage
  void _toggleFavorite(Recipe recipe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favorites.contains(recipe)) {
        _favorites.remove(recipe);
      } else {
        _favorites.add(recipe);
      }
      // Save favorites to local storage
      List<String> favoriteJsons = _favorites.map((recipe) => recipe.toJsonString()).toList();
      prefs.setStringList('favorites', favoriteJsons);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Finder'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(favorites: _favorites),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter ingredients (comma separated)',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchRecipes,
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _getRandomRecipe,
              child: Text('Get Random Recipe'),
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : Expanded(
              child: SingleChildScrollView(
                child: _randomRecipe != null
                    ? Column(
                  children: [
                    Image.network(_randomRecipe!.imageUrl),
                    SizedBox(height: 10),
                    Text(
                      _randomRecipe!.title,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Ingredients: ${_randomRecipe!.ingredients.join(", ")}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )
                    : _recipes.isEmpty
                    ? Center(child: Text('No recipes found'))
                    : ListView.builder(
                  shrinkWrap: true, // Important for scrolling
                  physics: NeverScrollableScrollPhysics(), // Disable internal scrolling
                  itemCount: _recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _recipes[index];
                    return Card(
                      child: ListTile(
                        leading: recipe.imageUrl.isNotEmpty
                            ? Image.network(
                          recipe.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                            : Container(width: 100, height: 100),
                        title: Text(recipe.title),
                        subtitle: Text('Ingredients: ${recipe.ingredients.join(', ')}'),
                        trailing: IconButton(
                          icon: Icon(
                            _favorites.contains(recipe) ? Icons.favorite : Icons.favorite_border,
                            color: _favorites.contains(recipe) ? Colors.red : null,
                          ),
                          onPressed: () => _toggleFavorite(recipe),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailPage(recipe: recipe),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
