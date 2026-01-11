import 'package:flutter/material.dart';
import '../core/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Delay untuk menampilkan splash screen
    await Future.delayed(const Duration(seconds: 2));

    final isLoggedIn = await AuthService.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      // User sudah login, langsung ke home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // User belum login, ke halaman login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8), // Warna cream seperti logo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/logo.jpg',
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 30),

            // Loading indicator
            const CircularProgressIndicator(
              color: Color(0xFFB85C38), // Warna coklat kemerahan seperti logo
              strokeWidth: 3,
            ),

            const SizedBox(height: 20),

            // Loading text
            Text(
              "Memuat...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
