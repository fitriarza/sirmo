import 'package:sirmo_app/core/network/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilPasienController {
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  Map<String, dynamic> dataProfil = {};

  Future<void> fetchProfil(String username) async {
    isLoading.value = true;
    try {
      // Ganti URL ini dengan link API/PHP kamu
      final response = await http.post(
      Uri.parse(ApiConstants.getProfilPasien), 
      headers: {"Content-Type": "application/json"},
      body: json.encode({'username': username}),
    );
      if (response.statusCode == 200) {
        dataProfil = json.decode(response.body);
      }
    } catch (e) {
      debugPrint("Error ambil profil: $e");
    }
    isLoading.value = false;
  }
  Future<bool> updateFullProfil(String username, String nama, String alamat, String nik, String hp, String tglLahir) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.updateProfil),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'username': username,
          'nama_lengkap': nama,
          'alamat': alamat,
          'nik': nik,
          'no_hp': hp,
          'tgl_lahir': tglLahir // 🟢 LEMPAR KE PHP
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint("Error update profil: $e");
      return false;
    }
  }
}