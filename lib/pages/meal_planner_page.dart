import 'package:flutter/material.dart';

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

  void _addMenu(String day) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Menu $day"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Contoh: Ayam Goreng",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("BATAL"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                weeklyMenu[day] = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text("SIMPAN"),
          ),
        ],
      ),
    );
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
              title: Text(
                day,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                menu.isEmpty ? "Belum ada menu" : menu,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _addMenu(day),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
