import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_constants.dart';

class InputMandiriController {
  final TextEditingController namaObatController = TextEditingController();
  final TextEditingController keluhanController = TextEditingController();

  Future<void> simpanCatatan(BuildContext context, String username) async {
    // 1. Debugging: Pastikan data inputan tertangkap
    debugPrint("DEBUG: Memulai simpan data...");
    debugPrint("DEBUG: Username yang diterima: '$username'");
    debugPrint("DEBUG: Nama Obat: '${namaObatController.text}'");
    debugPrint("DEBUG: Keluhan: '${keluhanController.text}'");

    if (namaObatController.text.isEmpty || keluhanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama obat dan keluhan tidak boleh kosong!')),
      );
      return;
    }

    try {
      var url = Uri.parse('${ApiConstants.baseUrl}/pasien/simpan_mandiri.php');
      
      // 2. Kirim data ke PHP
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "username": username.trim(), // Pakai trim() biar spasi hilang
          "nama_obat": namaObatController.text.trim(),
          "keluhan": keluhanController.text.trim(),
        }),
      );

      // 3. Debugging: Lihat apa yang dijawab oleh PHP
      debugPrint("DEBUG: Status Code: ${response.statusCode}");
      debugPrint("DEBUG: Respons PHP: ${response.body}");

      if (response.statusCode == 200) {
        var resBody = json.decode(response.body);
        
        if (resBody['success'] == true) {
          if (context.mounted) {
            Navigator.pop(context, true); // Kembali dan beri sinyal sukses
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Catatan berhasil disimpan!'), backgroundColor: Colors.green),
            );
          }
        } else {
          // Jika sukses false, tampilkan pesan dari PHP
          throw Exception(resBody['message'] ?? 'Gagal tidak diketahui');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("DEBUG: Error Exception: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${e.toString()}')),
        );
      }
    }
  }

  void dispose() {
    namaObatController.dispose();
    keluhanController.dispose();
  }
}