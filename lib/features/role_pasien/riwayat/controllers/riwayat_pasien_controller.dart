import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_constants.dart';

class RiwayatPasienController {
  final ValueNotifier<int> activeTab = ValueNotifier<int>(1);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);

  List<Map<String, dynamic>> riwayatDokter = [];
  List<Map<String, dynamic>> riwayatMandiri = [];

  void gantiTab(int index) {
    activeTab.value = index;
  }

  // 🟢 FUNGSI SEDOT DATA DARI MYSQL
  Future<void> fetchRiwayat(String username) async {
    try {
      isLoading.value = true;
      var url = Uri.parse('${ApiConstants.getRiwayatPasien}?username=$username');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['success'] == true) {
          // Parse data dokter
          riwayatDokter = List<Map<String, dynamic>>.from(data['riwayat_dokter'].map((item) => {
            'id_rm': item['id_rm'],
            'tanggal': item['tanggal'],
            'diagnosa': item['diagnosa'],
            'pemeriksa': item['pemeriksa'],
            'tipe': item['tipe'],
            'obat': List<String>.from(item['obat']),
          }));

          // Parse data mandiri
          riwayatMandiri = List<Map<String, dynamic>>.from(data['riwayat_mandiri'].map((item) => {
            'id_rm': item['id_rm'],
            'tanggal': item['tanggal'],
            'diagnosa': item['diagnosa'],
            'pemeriksa': item['pemeriksa'],
            'tipe': item['tipe'],
            'obat': List<String>.from(item['obat']),
          }));
        }
      }
    } catch (e) {
      debugPrint("Error narik riwayat: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> getListSesuaiTab(int tabIndex) {
    if (tabIndex == 1) return riwayatDokter;
    if (tabIndex == 2) return riwayatMandiri;
    
    // Jika Semua, gabungkan kedua array
    List<Map<String, dynamic>> semua = [...riwayatMandiri, ...riwayatDokter];
    return semua;
  }

  // 🟢 FUNGSI HAPUS CATATAN (DENGAN REFRESH)
  Future<bool> hapusCatatan(String idRiwayat, String username) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.hapusRiwayat), 
        headers: {"Content-Type": "application/json"},
        body: json.encode({'id_riwayat': idRiwayat})
      );

      if (response.statusCode == 200) {
        debugPrint("Data berhasil dihapus dari server");
        // Otomatis tarik ulang data setelah hapus agar tampilan refresh
        await fetchRiwayat(username);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error hapus catatan: $e");
      return false;
    }
  }
}