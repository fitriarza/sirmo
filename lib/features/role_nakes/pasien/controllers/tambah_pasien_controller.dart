import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_constants.dart';

class TambahPasienController {
  final TextEditingController nikController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tglLahirController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  String jenisKelamin = 'Laki-laki';
  bool isLoading = false;

  void dispose() {
    nikController.dispose();
    namaController.dispose();
    tglLahirController.dispose();
    noHpController.dispose();
    alamatController.dispose();
    passwordController.dispose();
  }

  Future<void> simpanPasien(BuildContext context, String usernameNakes, VoidCallback updateState) async {
    // Validasi input dasar
    if (nikController.text.isEmpty || namaController.text.isEmpty || noHpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NIK, Nama, dan No HP wajib diisi!'), backgroundColor: Colors.red),
      );
      return;
    }

    isLoading = true;
    updateState();

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.simpanPasien),
        body: {
          'username_nakes': usernameNakes, // Buat ngecek dia dari klinik mana
          'nik': nikController.text,
          'nama_lengkap': namaController.text,
          'tgl_lahir': tglLahirController.text,
          'jenis_kelamin': jenisKelamin,
          'no_hp': noHpController.text, // Ini akan jadi Username Pasien
          'alamat': alamatController.text,
          'password': passwordController.text.isNotEmpty ? passwordController.text : '123456', // Default pass kalau kosong
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['sukses'] == true) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(data['pesan']), backgroundColor: Colors.green),
            );
            Navigator.pop(context, true); // Kembali ke list dan kasih sinyal refresh
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(data['pesan']), backgroundColor: Colors.red),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Error Simpan Pasien: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan jaringan!'), backgroundColor: Colors.red),
        );
      }
    } finally {
      isLoading = false;
      updateState();
    }
  }
}