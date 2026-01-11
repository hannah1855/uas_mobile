class Recipe {
  final String id;
  final String name;
  final String cookTime;
  final String? imagePath; // path asset atau null jika tidak ada gambar
  final String ingredients;
  final String steps;
  final bool isFavorite;

  Recipe({
    required this.id,
    required this.name,
    required this.cookTime,
    this.imagePath,
    this.ingredients = '',
    this.steps = '',
    this.isFavorite = false,
  });

  // Method to create a copy with updated favorite status
  Recipe copyWith({
    String? id,
    String? name,
    String? cookTime,
    String? imagePath,
    String? ingredients,
    String? steps,
    bool? isFavorite,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      cookTime: cookTime ?? this.cookTime,
      imagePath: imagePath ?? this.imagePath,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
