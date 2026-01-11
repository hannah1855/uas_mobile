import 'package:flutter/material.dart';
import '../core/auth_service.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final int totalRecipes;
  final int totalFavorites;

  const ProfilePage({
    super.key,
    required this.totalRecipes,
    required this.totalFavorites,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // Get current user email from Supabase
    final userEmail = AuthService.getCurrentUserEmail() ?? "user@example.com";
    final userName = AuthService.getCurrentUserName();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
              userName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            // EMAIL (from Supabase)
            Text(userEmail, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 24),

            // INFO CARD
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoCard(
                  icon: Icons.restaurant_menu,
                  title: "Resep",
                  value: widget.totalRecipes.toString(),
                  color: Colors.blue,
                ),
                _infoCard(
                  icon: Icons.favorite,
                  title: "Favorit",
                  value: widget.totalFavorites.toString(),
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
                  // Tampilkan dialog konfirmasi
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
                    // Clear semua data login
                    await AuthService.clearLoginData();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
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
