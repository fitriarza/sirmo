import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sirmo_app/core/network/api_constants.dart';
import 'package:flutter/foundation.dart'; // 🟢 Tambahkan import untuk debugPrint

class SuperAdminKlinikController {
  
  // Fungsi untuk mengambil data dari API
  Future<List<dynamic>> getDaftarKlinik() async {
    try {
      // 🟢 Gunakan ApiConstants.getKlinikSuperAdmin
      final response = await http.get(Uri.parse(ApiConstants.getKlinikSuperAdmin));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['sukses']) {
          return data['data']; // Mengembalikan array data klinik
        } else {
          return []; // Jika kosong / sukses = false
        }
      } else {
        throw Exception('Gagal terhubung ke server');
      }
    } catch (e) {
      debugPrint("Error Fetching Klinik: $e");
      return [];
    }
  }
  // Fungsi untuk Aksi Reset Password & Ubah Status
  Future<Map<String, dynamic>> prosesAksiKlinik(String idKlinik, String aksi) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.aksiKlinikSuperAdmin),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_klinik': idKlinik,
          'aksi': aksi,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'sukses': false, 'message': 'Gagal terhubung ke server'};
    } catch (e) {
      debugPrint("Error Aksi Klinik: $e");
      return {'sukses': false, 'message': 'Terjadi kesalahan sistem'};
    }
  }
}