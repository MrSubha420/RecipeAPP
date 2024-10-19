# Recipe Finder 🍽️

A Flutter-based app that allows users to search for recipes based on ingredients they have at home, view detailed recipe information, save favorite recipes, and get random recipe suggestions.

## Key Features 🚀
- **Ingredient Input**: Input the ingredients you have on hand and find recipes that match.
- **Recipe Search**: Fetch recipes from a public API based on the ingredients provided.
- **Recipe Details**: View detailed information such as:
  - Cooking time
  - Number of servings
  - Ingredients
  - Step-by-step instructions
  - Nutritional information
- **Favorites**: Save recipes to favorites for quick access later using local storage.
- **Random Recipe**: Get inspiration by viewing a random recipe suggestion.

---

## Project Structure 📂

```bash
/recipe_finder
├── android/                # Android-specific files
├── ios/                    # iOS-specific files
├── lib/
│   ├── main.dart           # Main entry point of the app and Home Page
│   ├── recipe.dart         # Recipe model
│   ├── recipe_service.dart # Services for API calls and local storage
│   ├── recipe_detail.dart  # Detailed view of a recipe
│   ├── favorites_screen.dart  # Saved favorites screen
│   
├── pubspec.yaml            # Flutter dependencies
├── README.md               # Project documentation
```

## Getting Started 🛠️

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your machine.
- An API key from [Spoonacular API](https://spoonacular.com/food-api).
- go to the recipe_service.dart '**************' to 'Your own api key'

### Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/MRSubha420/RecipeAPP/recipe_finder.git
   cd recipe_finder_app
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run the app
  ```bash
  flutter run 

  ```

# IF you wank to .apk file for android 📂
  - go to the directory - [https://github.com/MRSubha420/RecipeAPP/ApkFile](https://github.com/MrSubha420/RecipeAPP/tree/main/ApkFile).
  - download base.apk 
  - install the apk -> run it
