import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_constants.dart';

class InputRekamMedisController {
  // Controller Teks
  final TextEditingController tekananDarahController = TextEditingController();
  final TextEditingController suhuController = TextEditingController();
  final TextEditingController keluhanController = TextEditingController();
  final TextEditingController diagnosaController = TextEditingController();
  final TextEditingController lamaSakitController = TextEditingController();
  final TextEditingController solusiCatatanController = TextEditingController();

  // State
  bool isLoading = false;
  bool isObatLoading = true;
  bool terbitSuratSakit = false;

  // Data List
  List<Map<String, dynamic>> masterObat = [];
  List<Map<String, dynamic>> listResepObat = [];

  void hancurkanController() {
    tekananDarahController.dispose();
    suhuController.dispose();
    keluhanController.dispose();
    diagnosaController.dispose();
    lamaSakitController.dispose();
    solusiCatatanController.dispose();
  }

  // 1. Tarik Master Obat dari Database
  Future<void> muatDaftarObat(VoidCallback updateUI) async {
    isObatLoading = true;
    updateUI();
    try {
      final response = await http.get(Uri.parse(ApiConstants.getObat));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['sukses'] == true) {
          masterObat = List<Map<String, dynamic>>.from(data['data']);
        }
      }
    } catch (e) {
      debugPrint("Error Get Obat: $e");
    } finally {
      isObatLoading = false;
      updateUI();
    }
  }

  // 2. Tambah Baris Resep di UI
  void tambahBarisObat(VoidCallback updateUI) {
    listResepObat.add({'id_obat': null, 'nama': '', 'dosis': ''});
    updateUI();
  }

  // 3. Tambah Obat Baru Instan ke MySQL
  Future<void> suntikObatBaruOnTheFly({
    required BuildContext context,
    required String namaObat,
    required String satuan,
    required int index,
    required VoidCallback updateUI,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.tambahObat),
        body: {'nama_obat': namaObat, 'satuan': satuan},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['sukses'] == true) {
          String newId = data['id_obat'].toString();
          // Masukkan ke master obat lokal biar langsung muncul di dropdown
          masterObat.add({'id_obat': newId, 'nama_obat': namaObat, 'satuan': satuan});
          // Set dropdown di baris tersebut
          listResepObat[index]['id_obat'] = newId;
          listResepObat[index]['nama'] = namaObat;
          updateUI();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Obat ditambahkan ke database!'), backgroundColor: Colors.green));
          }
        }
      }
    } catch (e) {
      debugPrint("Error Tambah Obat: $e");
    }
  }

  // 4. Simpan Full Rekam Medis
  Future<bool> kirimDataRekamMedisLive(String idPasien, String usernameNakes) async {
    if (keluhanController.text.isEmpty || diagnosaController.text.isEmpty) return false;

    isLoading = true;
    try {
      // Filter resep yang beneran diisi (ada id_obat dan dosisnya)
      List<Map<String, dynamic>> resepValid = listResepObat.where((r) => r['id_obat'] != null && r['dosis'].toString().isNotEmpty).toList();

      final response = await http.post(
        Uri.parse(ApiConstants.simpanRm),
        body: {
          'id_pasien': idPasien,
          'username_nakes': usernameNakes, // Untuk tahu klinik & dokternaknya
          'hasil_periksa': "Tensi: ${tekananDarahController.text}, Suhu: ${suhuController.text}",
          'keluhan': keluhanController.text,
          'diagnosa': diagnosaController.text,
          'surat_sakit': terbitSuratSakit ? '1' : '0',
          'lama_istirahat': terbitSuratSakit ? '${lamaSakitController.text} Hari' : '',
          'resep_json': jsonEncode(resepValid), // Kirim resep dalam bentuk JSON string
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        isLoading = false;
        return data['sukses'] == true;
      }
    } catch (e) {
      debugPrint("Error Simpan RM: $e");
    }
    isLoading = false;
    return false;
  }
}