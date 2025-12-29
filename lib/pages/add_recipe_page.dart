import 'package:flutter/material.dart';

class AddRecipePage extends StatelessWidget {
  const AddRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Resep"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // IMAGE PICKER (DUMMY)
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 40),
                    SizedBox(height: 8),
                    Text("Tambah Foto Makanan"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // NAMA RESEP
            TextFormField(
              decoration: InputDecoration(
                labelText: "Nama Resep",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // WAKTU MASAK
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Waktu Masak (menit)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // BAHAN
            TextFormField(
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Resep berhasil ditambahkan (dummy)"),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  "SIMPAN RESEP",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
