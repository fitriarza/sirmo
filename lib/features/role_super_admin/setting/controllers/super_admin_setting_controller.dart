import 'package:shared_preferences/shared_preferences.dart';

class SuperAdminSettingController {
  
  // Fungsi untuk membersihkan sesi login
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Hapus semua data sesi
      return true;
    } catch (e) {
      return false;
    }
  }
}