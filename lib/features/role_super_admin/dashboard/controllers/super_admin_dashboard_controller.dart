import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sirmo_app/core/network/api_constants.dart';
import 'package:flutter/foundation.dart';

class SuperAdminDashboardController {
  // Mengambil total statistik (Klinik, Pasien, Nakes) dari Database
  Future<Map<String, dynamic>> getDataDashboard() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getDashboardSuperAdmin),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['sukses'] == true) {
          // JSON API kamu bentuknya:
          // {"sukses":true,"total_klinik":1,"total_nakes":1,"klinik_pending":0,"nakes_pending":0}
          return {
            'total_klinik': (data['total_klinik'] ?? 0),
            'total_nakes': (data['total_nakes'] ?? 0),
            'klinik_pending': (data['klinik_pending'] ?? 0),
            'nakes_pending': (data['nakes_pending'] ?? 0),
          };
        }
      }

      // Jika gagal, kembalikan angka 0
      return {
        'total_klinik': 0,
        'total_nakes': 0,
        'klinik_pending': 0,
        'nakes_pending': 0,
      };
    } catch (e) {
      return {
        'total_klinik': 0,
        'total_nakes': 0,
        'klinik_pending': 0,
        'nakes_pending': 0,
      };
    }
  }

  // Masukkan fungsi ini ke dalam class SuperAdminDashboardController
  Future<String> getLatestLog() async {
    try {
      // Pastikan URL API 'getLatestLogSuperAdmin' sudah terdaftar di ApiConstants.dart
      final response = await http.get(
        Uri.parse(ApiConstants.getLatestLogSuperAdmin),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['nama_klinik'];
      }
    } catch (e) {
      debugPrint("Error Log: $e");
    }
    return "Belum ada data";
  }
}
