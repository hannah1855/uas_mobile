import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'edit_recipe_page.dart';

class RecipePage extends StatefulWidget {
  final Recipe recipe;
  final Function(Recipe)? onEdit;
  final Function(Recipe)? onDelete;
  final Function(Recipe)? onToggleFavorite;

  const RecipePage({
    super.key,
    required this.recipe,
    this.onEdit,
    this.onDelete,
    this.onToggleFavorite,
  });

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.recipe.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    if (widget.onToggleFavorite != null) {
      widget.onToggleFavorite!(widget.recipe);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? "\"${widget.recipe.name}\" ditambahkan ke favorit"
              : "\"${widget.recipe.name}\" dihapus dari favorit",
        ),
        backgroundColor: isFavorite ? Colors.green : Colors.grey,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Resep"),
        content: Text(
          "Apakah Anda yakin ingin menghapus resep \"${widget.recipe.name}\"?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("BATAL"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              if (widget.onDelete != null) {
                widget.onDelete!(widget.recipe);
              }
              Navigator.pop(context); // Go back to home
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Resep \"${widget.recipe.name}\" berhasil dihapus",
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("HAPUS"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
        backgroundColor: Colors.orange,
        actions: [
          // Favorite Button
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            tooltip: isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
            onPressed: _toggleFavorite,
          ),
          // Edit Button
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Resep',
            onPressed: () async {
              final updatedRecipe = await Navigator.push<Recipe>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditRecipePage(recipe: widget.recipe),
                ),
              );

              if (updatedRecipe != null && widget.onEdit != null) {
                widget.onEdit!(updatedRecipe);
                if (context.mounted) {
                  Navigator.pop(context); // Go back to home with updated data
                }
              }
            },
          ),
          // Delete Button
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Hapus Resep',
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image with Favorite Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: widget.recipe.imagePath != null
                      ? Image.asset(
                          widget.recipe.imagePath!,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: double.infinity,
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.restaurant,
                            size: 80,
                            color: Colors.orange,
                          ),
                        ),
                ),
                if (isFavorite)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 24,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Recipe Name and Favorite Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.recipe.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isFavorite)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite, color: Colors.red, size: 16),
                        SizedBox(width: 4),
                        Text(
                          "Favorit",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  widget.recipe.cookTime,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Bahan-bahan:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.recipe.ingredients.isNotEmpty
                    ? widget.recipe.ingredients
                    : "Belum ada bahan yang ditambahkan",
                style: TextStyle(
                  fontSize: 14,
                  color: widget.recipe.ingredients.isNotEmpty
                      ? Colors.black87
                      : Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Langkah Memasak:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.recipe.steps.isNotEmpty
                    ? widget.recipe.steps
                    : "Belum ada langkah yang ditambahkan",
                style: TextStyle(
                  fontSize: 14,
                  color: widget.recipe.steps.isNotEmpty
                      ? Colors.black87
                      : Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Info Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Tekan ❤️ untuk menambahkan ke favorit, atau ✏️ untuk mengedit resep.",
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
