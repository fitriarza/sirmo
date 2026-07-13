import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sirmo_app/core/network/api_constants.dart';
import 'package:file_picker/file_picker.dart' as fp;

class RegisterKlinikController {
  final TextEditingController namaKlinikController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noTelpController = TextEditingController();
  final TextEditingController namaOwnerController = TextEditingController();
  final TextEditingController nipStrController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  String? selectedProfesi;

  fp.PlatformFile? selectedFileIzin;
  fp.PlatformFile? selectedFileStr;

  final List<String> daftarProfesi = [
    'Dokter Umum',
    'Dokter Gigi',
    'Dokter Spesialis',
    'Perawat',
    'Bidan',
    'Apoteker',
    'Lainnya',
  ];

  void dispose() {
    namaKlinikController.dispose();
    alamatController.dispose();
    noTelpController.dispose();
    namaOwnerController.dispose();
    nipStrController.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  void togglePasswordVisibility(VoidCallback refresh) {
    obscurePassword = !obscurePassword;
    refresh();
  }

  void changeProfesi(String? value, VoidCallback refresh) {
    selectedProfesi = value;
    refresh();
  }

  Future<void> pickFileIzin(VoidCallback refresh) async {
    try {
      var result = await fp.FilePicker.pickFiles(
        type: fp.FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result?.files.isNotEmpty == true) {
        selectedFileIzin = result!.files.first;
        refresh();
      }
    } catch (e) {
      debugPrint("Gagal memilih file izin: $e");
    }
  }

  Future<void> pickFileStr(VoidCallback refresh) async {
    try {
      var result = await fp.FilePicker.pickFiles(
        type: fp.FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result?.files.isNotEmpty == true) {
        selectedFileStr = result!.files.first;
        refresh();
      }
    } catch (e) {
      debugPrint("Gagal memilih file STR: $e");
    }
  }

  Future<void> prosesRegisterKlinik(
    BuildContext context,
    VoidCallback refreshUI,
  ) async {
    isLoading = true;
    refreshUI();

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.registerKlinik),
      );

      request.fields['nama_klinik'] = namaKlinikController.text;
      request.fields['alamat'] = alamatController.text;
      request.fields['no_telp'] = noTelpController.text;
      request.fields['nama_owner'] = namaOwnerController.text;
      request.fields['profesi'] = selectedProfesi ?? '';
      request.fields['nip_str'] = nipStrController.text;
      request.fields['username'] = usernameController.text;
      request.fields['password'] = passwordController.text;

      if (selectedFileIzin != null) {
        if (kIsWeb) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'file_izin',
              selectedFileIzin!.bytes!,
              filename: selectedFileIzin!.name,
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              'file_izin',
              selectedFileIzin!.path!,
            ),
          );
        }
      }

      if (selectedFileStr != null) {
        if (kIsWeb) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'file_str',
              selectedFileStr!.bytes!,
              filename: selectedFileStr!.name,
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              'file_str',
              selectedFileStr!.path!,
            ),
          );
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (!context.mounted) return;

      final decoded = jsonDecode(response.body);

      // Sinkronisasi format respons dengan PHP register_klinik.php
      // PHP mengirim: {"status": "success"|"error", "message": "..."}
      final status = decoded['status'];
      final message = decoded['message'];

      if (status == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Klinik berhasil didaftarkan! Menunggu validasi.'),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal: ${message ?? decoded['pesan'] ?? 'Coba cek lagi!'}',
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error register klinik: $e");
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error koneksi: $e")));
    }

    isLoading = false;
    refreshUI();
  }
}
