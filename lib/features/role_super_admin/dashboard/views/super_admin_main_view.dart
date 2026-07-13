import 'package:flutter/material.dart';
import 'package:sirmo_app/shared_widgets/custom_bottom_bar_super_admin.dart';
import 'package:sirmo_app/features/role_super_admin/dashboard/views/super_admin_dashboard_view.dart';
import 'package:sirmo_app/features/role_super_admin/kelola_klinik/views/super_admin_klinik_view.dart';
import 'package:sirmo_app/features/role_super_admin/validasi/views/super_admin_validasi_view.dart';
import 'package:sirmo_app/features/role_super_admin/setting/views/super_admin_setting_view.dart';

class SuperAdminMainView extends StatefulWidget {
  const SuperAdminMainView({super.key});

  @override
  State<SuperAdminMainView> createState() => _SuperAdminMainViewState();
}

class _SuperAdminMainViewState extends State<SuperAdminMainView> {
  int _currentIndex = 0;

  // 🟢 DAFTAR HALAMAN SEKARANG ADA 4 (Sesuai dengan Bottom Bar)
  final List<Widget> _halaman = [
    const SuperAdminDashboardView(),                             // Index 0: Dasbor
    const SuperAdminKlinikView(),                                // Index 1: Klinik
    const SuperAdminValidasiView(),                              // Index 2: Validasi (Baru)
    const SuperAdminSettingView(),                               // Index 3: Pengaturan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _halaman,
      ),
      // 🟢 BAR INI AKAN MUNCUL DENGAN 4 TAB BARU!
      bottomNavigationBar: CustomBottomBarSuperAdmin(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}