import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';

  /// Simpan status login ke SharedPreferences
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  /// Cek apakah user sudah login
  /// Mengecek SharedPreferences DAN Supabase session
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLoginStatus = prefs.getBool(_isLoggedInKey) ?? false;

    // Double check dengan Supabase session
    final session = Supabase.instance.client.auth.currentSession;

    // User dianggap logged in jika:
    // 1. SharedPreferences menyimpan is_logged_in = true
    // 2. DAN Supabase masih punya session valid
    return savedLoginStatus && session != null;
  }

  /// Clear semua data login (untuk logout)
  static Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await Supabase.instance.client.auth.signOut();
  }

  /// Get current user email
  static String? getCurrentUserEmail() {
    return Supabase.instance.client.auth.currentUser?.email;
  }

  /// Get current user name (from metadata or email)
  static String getCurrentUserName() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return "User";

    // Coba ambil dari metadata
    final metadata = user.userMetadata;
    if (metadata != null) {
      if (metadata.containsKey('name')) return metadata['name'];
      if (metadata.containsKey('full_name')) return metadata['full_name'];
    }

    // Fallback ke email (ambil sebelum @)
    if (user.email != null && user.email!.contains('@')) {
      final emailName = user.email!.split('@')[0];
      // Capitalize first letter
      return emailName[0].toUpperCase() + emailName.substring(1);
    }

    return "User";
  }

  /// Update user profile (metadata)
  static Future<void> updateProfile({required String name}) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception("Belum login");

    await Supabase.instance.client.auth.updateUser(
      UserAttributes(data: {'name': name, 'full_name': name}),
    );
  }
}
