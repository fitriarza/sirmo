import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_constants.dart';

class DaftarPasienController {
  bool isLoading = true;
  
  // listPasien untuk nyimpan data asli dari database
  List<Map<String, dynamic>> listPasien = [];
  
  // pasienFilter untuk nampilin data di layar (bisa berubah kalau di-search)
  List<Map<String, dynamic>> pasienFilter = [];

  // 1. Fungsi Tarik Data dari XAMPP
  Future<void> muatDataPasien(String usernameNakes) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.getPasien),
        body: {'username': usernameNakes}, // Kirim username nakes ke PHP
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['sukses'] == true) {
          List<Map<String, dynamic>> fetchedData = List<Map<String, dynamic>>.from(data['data']);
          listPasien = fetchedData;
          pasienFilter = fetchedData; 
        }
      }
    } catch (e) {
      debugPrint("Error Fetch Data Pasien: $e");
    } finally {
      isLoading = false;
    }
  }

  // 2. Fungsi Pencarian Lokal (Cari berdasarkan Nama atau NIK)
  void filterPencarian(String keyword) {
    if (keyword.isEmpty) {
      pasienFilter = listPasien; // Kalau kolom search kosong, balikin semua data
    } else {
      pasienFilter = listPasien.where((pasien) {
        final nama = pasien['nama_lengkap']?.toString().toLowerCase() ?? '';
        final nik = pasien['nik']?.toString().toLowerCase() ?? '';
        final kataKunci = keyword.toLowerCase();
        
        return nama.contains(kataKunci) || nik.contains(kataKunci);
      }).toList();
    }
  }
  // 3. Fungsi Tarik Pasien Global
  Future<bool> tarikPasienGlobal(BuildContext context, String usernamePasien, String usernameNakes, VoidCallback updateState) async {
    isLoading = true;
    updateState();
    
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.tarikPasienGlobal),
        body: {
          'username_pasien': usernamePasien,
          'username_nakes': usernameNakes,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (context.mounted) {
          if (data['sukses'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['pesan']), backgroundColor: Colors.green));
            return true;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['pesan']), backgroundColor: Colors.red));
            return false;
          }
        }
      }
    } catch (e) {
      debugPrint("Error Tarik Pasien Global: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Terjadi kesalahan jaringan!'), backgroundColor: Colors.red));
      }
    } finally {
      isLoading = false;
      updateState();
    }
    return false;
  }
}