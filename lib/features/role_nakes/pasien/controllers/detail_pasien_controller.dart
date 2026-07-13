import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_constants.dart';

class DetailPasienController {
  bool isLoading = true;
  List<Map<String, dynamic>> listRiwayat = [];

  // 🟢 Fungsi tarik riwayat RM khusus untuk "Klinik Ini"
  Future<void> muatRiwayatRMLive(String idPasien, String usernameNakes, VoidCallback updateState) async {
    isLoading = true;
    // Panggil updateState agar UI menampilkan loading mutar
    Future.microtask(() => updateState());

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.getRiwayatRm),
        body: {
          'id_pasien': idPasien,
          'username_nakes': usernameNakes, // Kunci utama privasi klinik
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['sukses'] == true) {
          listRiwayat = List<Map<String, dynamic>>.from(data['data']);
        } else {
          listRiwayat = [];
        }
      }
    } catch (e) {
      debugPrint("Error Fetch Riwayat RM: $e");
      listRiwayat = [];
    } finally {
      isLoading = false;
      updateState(); // Hilangkan loading setelah selesai
    }
  }
}