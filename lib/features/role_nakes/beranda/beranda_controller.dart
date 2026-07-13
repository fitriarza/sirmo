import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../core/network/api_constants.dart';

class BerandaController {
  // 🟢 1. TERIMA PARAMETER USERNAME
  Future<Map<String, dynamic>> fetchDashboardStats(String username) async {
    try {
      // 🟢 2. UBAH JADI POST DAN KIRIM USERNAME
      var response = await http.post(
        Uri.parse(ApiConstants.getDashboardNakes),
        body: {
          'username_nakes': username,
        }
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['success'] == true) {
          return {
            'pasienHariIni': data['pasien_hari_ini'] ?? 0,
            'totalPasien': data['total_pasien'] ?? 0,
            'totalObat': data['total_obat'] ?? 0,
            'listPenyakit': List<dynamic>.from(data['list_penyakit'] ?? []),
            'listObat': List<dynamic>.from(data['list_obat'] ?? []),
            'grafik': List<int>.from(data['grafik_kunjungan'] ?? [0, 0, 0, 0, 0, 0, 0]),
          };
        }
      }
      return _emptyData();
    } catch (e) {
      debugPrint("Error narik data dashboard: $e");
      return _emptyData();
    }
  }

  Map<String, dynamic> _emptyData() {
    return {
      'pasienHariIni': 0, 'totalPasien': 0, 'totalObat': 0,
      'listPenyakit': [], 'listObat': [], 'grafik': [0, 0, 0, 0, 0, 0, 0]
    };
  }
}