import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sirmo_app/core/network/api_constants.dart';

class SuperAdminValidasiController {
  
  Future<Map<String, List<dynamic>>> getDataValidasi() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.getValidasiSuperAdmin));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['sukses']) {
          return {
            'nakes': data['data_nakes'] ?? [], 
            'klinik': data['data_klinik'] ?? [], 
          };
        }
      }
      return {'nakes': [], 'klinik': []}; 
    } catch (e) {
      debugPrint("Error Fetching Validasi: $e");
      return {'nakes': [], 'klinik': []};
    }
  }

  // Fungsi untuk setujui Nakes
  Future<bool> setujuiNakes(String idUser) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.setujuiNakes), 
        body: {'id_user': idUser}, 
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['sukses'] ?? false;
      }
      return false;
    } catch (e) {
      debugPrint("Error Setujui Nakes: $e");
      return false;
    }
  }

  // 🟢 Nah, fungsi ini sekarang udah MASUK ke dalam pagar class!
  // Mengeksekusi tombol Setujui / Tolak ke Database
  Future<bool> prosesValidasi(String tipe, String id, String aksi) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.prosesValidasiSuperAdmin),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tipe': tipe,
          'id': id,
          'aksi': aksi,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['sukses'] ?? false;
      }
      return false;
    } catch (e) {
      debugPrint("Error Proses Validasi: $e");
      return false;
    }
  }
}