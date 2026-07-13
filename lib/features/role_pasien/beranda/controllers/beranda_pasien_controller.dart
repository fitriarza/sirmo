import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sirmo_app/core/network/api_constants.dart';

class BerandaPasienController {
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  String namaLengkap = "";
  String noRm = "";
  String pinAkses = "123456"; // 🟢 VARIABEL BARU UNTUK PIN
  List<Map<String, dynamic>> frekuensiSakit = [];
  List<Map<String, dynamic>> aktivitasTerbaru = [];

  Future<void> fetchDashboard(String username) async {
    isLoading.value = true;
    
    try {
      var url = Uri.parse(ApiConstants.getDashboardPasien);
      var response = await http.post(url, body: {
        'username': username,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          namaLengkap = data['data']['nama_lengkap'] ?? '';
          noRm = data['data']['no_rm'] ?? '';
          // 🟢 TANGKAP PIN DARI DATABASE (Kalau kosong, set default 123456)
          pinAkses = data['data']['pin_akses'] ?? '123456'; 
          
          frekuensiSakit = List<Map<String, dynamic>>.from(data['data']['frekuensi_sakit'] ?? []);
          aktivitasTerbaru = List<Map<String, dynamic>>.from(data['data']['aktivitas_terbaru'] ?? []);
        }
      }
    } catch (e) {
      debugPrint("Error tarik data Beranda: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // 🟢 FUNGSI BARU UNTUK UPDATE PIN
  // 🟢 FUNGSI BARU UNTUK UPDATE PIN (SUDAH PAKAI API CONSTANTS)
  Future<bool> updatePinAkses(String username, String pinBaru) async {
    try {
      // 🟢 Pakai URL dari ApiConstants
      var url = Uri.parse(ApiConstants.updatePin); 
      var response = await http.post(url, body: {
        'username': username,
        'pin_akses': pinBaru,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['status'] == 'success';
      }
    } catch (e) {
      debugPrint("Error update PIN: $e");
    }
    return false;
  }
}