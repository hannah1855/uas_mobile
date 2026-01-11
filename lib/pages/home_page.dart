import 'package:flutter/material.dart';
import '../core/auth_service.dart';
import '../models/recipe.dart';
import 'add_recipe_page.dart';
import 'edit_profile_page.dart';
import 'meal_planner_page.dart';
import 'recipe_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Daftar resep (bisa ditambah dari AddRecipePage)
  List<Recipe> recipes = [
    Recipe(
      id: '1',
      name: 'Ayam Goreng',
      cookTime: '30 menit',
      imagePath: 'assets/Ayam_Goreng.jpg',
      ingredients: '- 1 ekor ayam\n- Bawang putih\n- Garam\n- Minyak goreng',
      steps:
          '1. Marinasi ayam dengan bumbu\n2. Goreng hingga matang kecoklatan',
    ),
    Recipe(
      id: '2',
      name: 'Nasi Goreng',
      cookTime: '15 menit',
      imagePath: 'assets/Nasi_goreng.jpg',
      ingredients: '- Nasi\n- Telur\n- Kecap\n- Bawang',
      steps: '1. Tumis bawang\n2. Masukkan nasi dan kecap\n3. Aduk rata',
    ),
    Recipe(
      id: '3',
      name: 'Soto Ayam',
      cookTime: '45 menit',
      imagePath: 'assets/Soto_ayam.jpg',
      ingredients: '- Ayam\n- Kunyit\n- Serai\n- Daun jeruk',
      steps: '1. Rebus ayam\n2. Tumis bumbu\n3. Campurkan semua',
    ),
    Recipe(
      id: '4',
      name: 'Rendang',
      cookTime: '120 menit',
      imagePath: 'assets/rendang.jpg',
      ingredients: '- Daging sapi\n- Santan\n- Bumbu rendang',
      steps: '1. Tumis bumbu\n2. Masukkan daging\n3. Masak hingga kering',
    ),
  ];

  void _addNewRecipe(Recipe newRecipe) {
    setState(() {
      recipes.add(newRecipe);
    });
  }

  void _updateRecipe(Recipe updatedRecipe) {
    setState(() {
      final index = recipes.indexWhere((r) => r.id == updatedRecipe.id);
      if (index != -1) {
        recipes[index] = updatedRecipe;
      }
    });
  }

  void _deleteRecipe(Recipe recipeToDelete) {
    setState(() {
      recipes.removeWhere((r) => r.id == recipeToDelete.id);
    });
  }

  void _toggleFavorite(Recipe recipe) {
    setState(() {
      final index = recipes.indexWhere((r) => r.id == recipe.id);
      if (index != -1) {
        recipes[index] = recipe.copyWith(isFavorite: !recipe.isFavorite);
      }
    });
  }

  int get totalRecipes => recipes.length;
  int get totalFavorites => recipes.where((r) => r.isFavorite).length;

  Future<void> _navigateToAddRecipe() async {
    final newRecipe = await Navigator.push<Recipe>(
      context,
      MaterialPageRoute(builder: (_) => const AddRecipePage()),
    );

    if (newRecipe != null) {
      _addNewRecipe(newRecipe);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? "Masak Apa Hari Ini?" : "Profil Saya"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: _currentIndex == 0 ? _buildHomeContent() : _buildProfileContent(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Button
            IconButton(
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0 ? Colors.orange : Colors.grey,
                size: 26,
              ),
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
              tooltip: 'Home',
            ),
            // Spacer for FAB
            const SizedBox(width: 40),
            // Profile Button
            IconButton(
              icon: Icon(
                Icons.person,
                color: _currentIndex == 1 ? Colors.orange : Colors.grey,
                size: 26,
              ),
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
              tooltip: 'Profil',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: _navigateToAddRecipe,
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHomeContent() {
    // Determine greeting based on time of day
    final hour = DateTime.now().hour;
    String greeting;
    if (hour >= 5 && hour < 11) {
      greeting = "Selamat Pagi";
    } else if (hour >= 11 && hour < 15) {
      greeting = "Selamat Siang";
    } else if (hour >= 15 && hour < 18) {
      greeting = "Selamat Sore";
    } else {
      greeting = "Selamat Malam";
    }
    final userName = AuthService.getCurrentUserName();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personalized Greeting
          Text(
            "$greeting, $userName!",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Siap memasak hari ini? Saya siapkan beberapa menu rekomendasi nih.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.all(16),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MealPlannerPage()),
              );
            },
            child: const Text("Meal Planner"),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: recipes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Belum ada resep",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Tekan tombol + untuk menambahkan resep baru",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    itemCount: recipes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipePage(
                                recipe: recipe,
                                onEdit: _updateRecipe,
                                onDelete: _deleteRecipe,
                                onToggleFavorite: _toggleFavorite,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: recipe.imagePath != null
                                          ? Image.asset(
                                              recipe.imagePath!,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              width: double.infinity,
                                              color: Colors.orange.shade100,
                                              child: const Icon(
                                                Icons.restaurant,
                                                size: 50,
                                                color: Colors.orange,
                                              ),
                                            ),
                                    ),
                                    // Favorite indicator
                                    if (recipe.isFavorite)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "⏱ ${recipe.cookTime}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    final userEmail = AuthService.getCurrentUserEmail() ?? "user@example.com";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // FOTO PROFIL
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange.shade100,
              border: Border.all(color: Colors.orange, width: 3),
            ),
            child: const Icon(Icons.person, size: 50, color: Colors.orange),
          ),

          const SizedBox(height: 12),

          // USERNAME
          Text(
            AuthService.getCurrentUserName(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          // EMAIL
          Text(userEmail, style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 24),

          // INFO CARD
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _infoCard(
                icon: Icons.restaurant_menu,
                title: "Resep",
                value: totalRecipes.toString(),
                color: Colors.blue,
              ),
              _infoCard(
                icon: Icons.favorite,
                title: "Favorit",
                value: totalFavorites.toString(),
                color: Colors.red,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // EDIT PROFILE
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );

                // Jika result = true (ada perubahan), refresh UI
                if (result == true) {
                  setState(() {});
                }
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profil"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // LOGOUT
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Apakah Anda yakin ingin logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("BATAL"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("LOGOUT"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await AuthService.clearLoginData();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                }
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text("Logout", style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
