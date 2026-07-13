import 'dart:convert';
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sirmo_app/core/network/api_constants.dart';
import 'package:file_picker/file_picker.dart' as fp; // 🟢 Pakai alias fp biar dipaksa baca

class RegisterController {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nipStrController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool isLoadingKlinik = false;
  String selectedRole = 'Pasien';
  String? selectedKlinik;
  String? selectedProfesi;
  
  String? selectedDocumentName;
  fp.PlatformFile? selectedDocumentFile; // 🟢 Pakai alias fp

  List<dynamic> listKlinik = [];
  final List<String> daftarProfesi = [
    'Dokter Umum', 'Dokter Gigi', 'Dokter Spesialis', 
    'Perawat', 'Bidan', 'Apoteker', 'Lainnya',
  ];

  void dispose() {
    namaController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    nipStrController.dispose();
  }

  void togglePasswordVisibility(VoidCallback refresh) {
    obscurePassword = !obscurePassword;
    refresh();
  }

  void changeRole(String role, VoidCallback refresh) {
    selectedRole = role;
    refresh();
  }

  void changeProfesi(String? value, VoidCallback refresh) {
    selectedProfesi = value;
    refresh();
  }

  Future<void> fetchKlinik(Function refreshUI) async {
    isLoadingKlinik = true;
    refreshUI();
    try {
      final response = await http.get(Uri.parse(ApiConstants.getKlinikList));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['sukses'] == true) {
          listKlinik = decoded['data']; 
        }
      }
    } catch (e) {
      debugPrint("Error load klinik: $e");
    }
    isLoadingKlinik = false;
    refreshUI();
  }

  Future<void> pickDocumentFile(BuildContext context, VoidCallback refresh) async {
    try {
      var result = await fp.FilePicker.pickFiles(
        type: fp.FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true, 
      );

      // 🟢 Trik aman anti garis kuning
      if (result?.files.isNotEmpty == true) {
        selectedDocumentFile = result!.files.first;
        selectedDocumentName = selectedDocumentFile!.name;
        refresh(); 
      }
    } catch (e) {
      if (!context.mounted) return; 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal memilih file: $e")));
    }
  }

  Future<void> prosesRegister(BuildContext context, Function refreshUI) async {
    isLoading = true;
    refreshUI();

    try {
      if (selectedRole == 'Pasien') {
        final response = await http.post(
          Uri.parse(ApiConstants.registerPasien),
          body: {
            'nama_lengkap': namaController.text,
            'username': usernameController.text,
            'password': passwordController.text,
          },
        );
        if (!context.mounted) return; 
        _handleResponse(response.body, context);

      } else {
        var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.registerNakes));
        
        request.fields['username'] = usernameController.text;
        request.fields['password'] = passwordController.text;
        request.fields['nama_lengkap'] = namaController.text;
        request.fields['id_klinik'] = selectedKlinik ?? '';
        request.fields['profesi'] = selectedProfesi ?? '';
        request.fields['nip_str'] = nipStrController.text;

        if (selectedDocumentFile != null) {
          if (kIsWeb) {
            request.files.add(http.MultipartFile.fromBytes(
              'file_str',
              selectedDocumentFile!.bytes!,
              filename: selectedDocumentFile!.name,
            ));
          } else {
            request.files.add(await http.MultipartFile.fromPath(
              'file_str',
              selectedDocumentFile!.path!,
            ));
          }
        }

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        
        if (!context.mounted) return; 
        _handleResponse(response.body, context);
      }
    } catch (e) {
      debugPrint("Error register: $e");
      if (!context.mounted) return; 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error koneksi: $e")));
    }

    isLoading = false;
    refreshUI();
  }

  void _handleResponse(String responseBody, BuildContext context) {
    final decoded = jsonDecode(responseBody);
    if (decoded['sukses'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(selectedRole == 'Pasien' ? 'Akun Pasien berhasil dibuat!' : 'Pendaftaran Berhasil! Menunggu validasi.')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: ${decoded['pesan'] ?? 'Coba cek lagi!'}')));
    }
  }
}