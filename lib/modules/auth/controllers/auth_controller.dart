import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sirmo_app/features/role_nakes/dashboard/dashboard_view.dart';
import 'dart:convert';
import '../../../core/network/api_constants.dart';
import 'package:sirmo_app/features/role_pasien/dashboard/views/dashboard_pasien_view.dart';
import 'package:sirmo_app/features/role_super_admin/dashboard/views/super_admin_main_view.dart';
import 'package:sirmo_app/features/role_super_admin/validasi/views/waiting_validasi_view.dart';

class AuthController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  bool isLoading = false;
  bool obscurePassword = true;

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }

  void togglePasswordVisibility(VoidCallback refresh) {
    obscurePassword = !obscurePassword;
    refresh();
  }
Future<void> prosesLogin(BuildContext context, VoidCallback refreshUI) async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Isi data dulu, Wak!")));
      return;
    }

    refreshUI();
    isLoading = true;

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        body: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );

      final result = jsonDecode(response.body);

      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Berhasil!")));
        
        String role = result['data']['role'];
        String username = result['data']['username'];

        // Cek Role dan pindah halaman
        if (role.toLowerCase() == 'pasien') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardPasienView(
                username: username,
                noRm: 'RM-XXXX', 
              ),
            ),
          );
        } 
        else if (role.toLowerCase() == 'superadmin' || role.toLowerCase() == 'super admin' || role.toLowerCase() == 'super_admin' || role.toLowerCase() == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SuperAdminMainView(), 
            ),
          );
        } 
        else if (role.toLowerCase() == 'nakes') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              // Pastikan variabel username ini sudah kamu tangkap dari response API login sebelumnya ya
              builder: (context) => DashboardView(username: username), 
            ),
          );
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Dashboard untuk role $role belum siap!")));
        }
      } else {
        // 🟢 CEGAT PESAN VALIDASI DI SINI WAK!
        if (result['message'] == 'Akun Anda belum divalidasi Admin!') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WaitingValidasiView(
                username: usernameController.text, 
              ),
            ),
          );
        } else {
          // Error lain (seperti password salah) masuk ke sini
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
        }
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      isLoading = false;
      refreshUI();
    }
  }
}