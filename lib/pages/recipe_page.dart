import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Resep"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "Ayam_Goreng.jpg",
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Ayam Goreng Krispi",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Bahan:\n- Ayam\n- Tepung\n- Bawang\n- Garam\n- Merica",
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 16),

            const Text(
              "Langkah:\n1. Marinasi ayam\n2. Balur tepung\n3. Goreng hingga keemasan",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
