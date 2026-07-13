import 'dart:convert'; // Wajib buat json.encode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Wajib buat http.post
import '../../../../core/network/api_constants.dart'; // Wajib buat panggil link API

class DetailMandiriController {
  Map<String, dynamic> data = {};

  // Menginisialisasi data yang dikirim dari halaman riwayat
  void initData(Map<String, dynamic> incomingData) {
    data = incomingData;
  }

  // Getters untuk memproses logika string/teks agar View tetap bersih
  String get tanggal => data['tanggal'] ?? '-';
  
  String get sumberData => data['pemeriksa'] ?? 'Input Mandiri';
  
  String get keluhan => data['diagnosa'] ?? '-';
  
  String get namaObat {
    if (data['obat'] != null && data['obat'].isNotEmpty) {
      return data['obat'][0];
    }
    return 'Tidak ada obat';
  }
  Future<void> hapusCatatan(String idRiwayat) async {
  try {
    final response = await http.post(
      Uri.parse(ApiConstants.hapusRiwayat),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'id_riwayat': idRiwayat}),
    );
    
    if (response.statusCode == 200) {
      debugPrint("Data berhasil dihapus dari server");
    }
  } catch (e) {
    debugPrint("Error hapus catatan: $e");
  }
}
}