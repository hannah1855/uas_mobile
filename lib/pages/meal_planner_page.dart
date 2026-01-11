import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'add_recipe_page.dart';

class MealPlannerPage extends StatefulWidget {
  const MealPlannerPage({super.key});

  @override
  State<MealPlannerPage> createState() => _MealPlannerPageState();
}

class _MealPlannerPageState extends State<MealPlannerPage> {
  final Map<String, String> weeklyMenu = {
    'Senin': '',
    'Selasa': '',
    'Rabu': '',
    'Kamis': '',
    'Jumat': '',
    'Sabtu': '',
    'Minggu': '',
  };

  // Daftar resep yang tersedia
  List<Recipe> availableRecipes = [
    Recipe(
      id: '1',
      name: 'Ayam Goreng',
      cookTime: '30 menit',
      imagePath: 'assets/Ayam_Goreng.jpg',
    ),
    Recipe(id: '2', name: 'Nasi Goreng', cookTime: '15 menit', imagePath: 'assets/Nasi_goreng.jpg'),
    Recipe(id: '3', name: 'Soto Ayam', cookTime: '45 menit', imagePath: 'assets/Soto_ayam.jpg'),
    Recipe(id: '4', name: 'Rendang', cookTime: '120 menit', imagePath: 'assets/rendang.jpg'),
  ];

  void _selectMenu(String day) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildMenuSelector(day),
    );
  }

  Widget _buildMenuSelector(String day) {
    return Container(
      padding: const EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pilih Menu untuk $day",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),

          // Daftar resep
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableRecipes.length,
              itemBuilder: (context, index) {
                final recipe = availableRecipes[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: recipe.imagePath != null
                        ? Image.asset(
                            recipe.imagePath!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            color: Colors.orange.shade100,
                            child: const Icon(
                              Icons.restaurant,
                              color: Colors.orange,
                            ),
                          ),
                  ),
                  title: Text(recipe.name),
                  subtitle: Text("⏱ ${recipe.cookTime}"),
                  trailing: weeklyMenu[day] == recipe.name
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    setState(() {
                      weeklyMenu[day] = recipe.name;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),

          const Divider(),

          // Opsi tambah menu baru
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, color: Colors.orange),
            ),
            title: const Text(
              "Tambahkan Menu Baru",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            subtitle: const Text("Buat resep baru"),
            onTap: () async {
              Navigator.pop(context); // Tutup bottom sheet

              // Navigate ke AddRecipePage
              final newRecipe = await Navigator.push<Recipe>(
                context,
                MaterialPageRoute(builder: (_) => const AddRecipePage()),
              );

              // Jika ada resep baru, tambahkan ke list dan set sebagai menu hari ini
              if (newRecipe != null) {
                setState(() {
                  availableRecipes.add(newRecipe);
                  weeklyMenu[day] = newRecipe.name;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  void _clearMenu(String day) {
    setState(() {
      weeklyMenu[day] = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Planner Mingguan"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: weeklyMenu.keys.map((day) {
          final menu = weeklyMenu[day]!;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: menu.isEmpty
                      ? Colors.grey.shade200
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  menu.isEmpty ? Icons.calendar_today : Icons.restaurant,
                  color: menu.isEmpty ? Colors.grey : Colors.orange,
                ),
              ),
              title: Text(
                day,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                menu.isEmpty ? "Belum ada menu" : menu,
                style: TextStyle(
                  color: menu.isEmpty ? Colors.grey : Colors.black87,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (menu.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.red),
                      onPressed: () => _clearMenu(day),
                      tooltip: 'Hapus menu',
                    ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => _selectMenu(day),
                    tooltip: 'Pilih menu',
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
