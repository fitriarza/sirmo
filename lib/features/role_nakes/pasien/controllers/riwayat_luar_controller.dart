import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/network/api_constants.dart';

class RiwayatLuarController {
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  List<Map<String, dynamic>> listRiwayat = [];

  Future<Map<String, dynamic>> getDetailNakes(String username) async {
    try {
      var url = Uri.parse(ApiConstants.getProfilNakes); 
      var response = await http.post(url, body: {'username': username});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // Sesuaikan dengan respon PHP yang menggunakan kunci "sukses"
        if (data['sukses'] == true) { 
          return Map<String, dynamic>.from(data['data']);
        }
      }
    } catch (e) {
      debugPrint("Error ambil profil nakes: $e");
    }
    return {'id_klinik': '0'}; // Default jika gagal
  }

  // Tambahkan parameter idKlinikNakes
  Future<void> fetchRiwayatLuar(String idPasien, String idKlinikNakes) async {
    debugPrint("--- DEBUG RIWAYAT ---");
    debugPrint("Pasien ID: $idPasien");
    debugPrint("Klinik Nakes ID yang dikirim: $idKlinikNakes");
    debugPrint("---------------------");

    isLoading.value = true;
    isLoading.value = true;
    try {
      var url = Uri.parse(ApiConstants.getRiwayatLuar);
      var response = await http.post(
        url,
        body: {
          'id_pasien': idPasien,
          'id_klinik_nakes': idKlinikNakes, // Kirim ke PHP
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          listRiwayat = List<Map<String, dynamic>>.from(data['data']);
        }
      }
    } catch (e) {
      debugPrint("Error ambil riwayat luar: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
