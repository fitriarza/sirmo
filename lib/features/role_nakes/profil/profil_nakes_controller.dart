import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_constants.dart';

class ProfilNakesController {
  
  // 1. FUNGSI READ (Ambil Data Profil)
  Future<Map<String, dynamic>> fetchProfilData(String username) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.getProfilNakes),
        body: {'username': username},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['sukses'] == true) {
          return data['data'];
        }
      }
    } catch (e) {
      debugPrint("Error Fetch Profil Nakes: $e");
    }
    return {}; // Return kosong jika gagal
  }

  // 2. FUNGSI UPDATE (Edit Data Profil - Persiapan CRUD)
  Future<bool> updateProfilData(String username, String namaLengkap, String profesi, String nipStr) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.updateProfilNakes),
        body: {
          'username': username,
          'nama_lengkap': namaLengkap,
          'profesi': profesi,
          'nip_str': nipStr,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['sukses'] ?? false;
      }
    } catch (e) {
      debugPrint("Error Update Profil Nakes: $e");
    }
    return false;
  }
}