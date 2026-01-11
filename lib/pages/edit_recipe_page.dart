import 'package:flutter/material.dart';
import '../models/recipe.dart';

class EditRecipePage extends StatefulWidget {
  final Recipe recipe;

  const EditRecipePage({super.key, required this.recipe});

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController cookTimeController;
  late TextEditingController ingredientsController;
  late TextEditingController stepsController;

  @override
  void initState() {
    super.initState();
    // Parse cook time to remove " menit" suffix if exists
    String cookTime = widget.recipe.cookTime;
    if (cookTime.endsWith(' menit')) {
      cookTime = cookTime.replaceAll(' menit', '');
    }

    nameController = TextEditingController(text: widget.recipe.name);
    cookTimeController = TextEditingController(text: cookTime);
    ingredientsController = TextEditingController(
      text: widget.recipe.ingredients,
    );
    stepsController = TextEditingController(text: widget.recipe.steps);
  }

  @override
  void dispose() {
    nameController.dispose();
    cookTimeController.dispose();
    ingredientsController.dispose();
    stepsController.dispose();
    super.dispose();
  }

  void _saveRecipe() {
    if (!_formKey.currentState!.validate()) return;

    final updatedRecipe = Recipe(
      id: widget.recipe.id,
      name: nameController.text.trim(),
      cookTime: '${cookTimeController.text.trim()} menit',
      imagePath: widget.recipe.imagePath, // Keep original image
      ingredients: ingredientsController.text.trim(),
      steps: stepsController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Resep berhasil diperbarui!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, updatedRecipe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Resep"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE PREVIEW
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: widget.recipe.imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          widget.recipe.imagePath!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant,
                              size: 50,
                              color: Colors.orange,
                            ),
                            SizedBox(height: 8),
                            Text("Tidak ada gambar"),
                          ],
                        ),
                      ),
              ),

              const SizedBox(height: 20),

              // NAMA RESEP
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Nama Resep",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) =>
                    v!.isEmpty ? "Nama resep tidak boleh kosong" : null,
              ),

              const SizedBox(height: 16),

              // WAKTU MASAK
              TextFormField(
                controller: cookTimeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Waktu Masak (menit)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) =>
                    v!.isEmpty ? "Waktu masak tidak boleh kosong" : null,
              ),

              const SizedBox(height: 16),

              // BAHAN
              TextFormField(
                controller: ingredientsController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Bahan-bahan",
                  hintText: "- Ayam\n- Bawang\n- Garam",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // LANGKAH
              TextFormField(
                controller: stepsController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Langkah Memasak",
                  hintText: "1. Marinasi ayam\n2. Goreng hingga matang",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // BUTTON SIMPAN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _saveRecipe,
                  child: const Text(
                    "SIMPAN PERUBAHAN",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
