import 'package:flutter/material.dart';
import '../../../../shared_widgets/custom_bottom_bar_pasien.dart';
import '../controllers/dashboard_pasien_controller.dart';
import '../../beranda/views/beranda_pasien_view.dart';
import '../../riwayat/views/riwayat_pasien_view.dart';
import '../../profil/views/profil_pasien_view.dart';

class DashboardPasienView extends StatefulWidget {
  final String username;
  final String noRm;

  const DashboardPasienView({
    super.key,
    required this.username,
    required this.noRm,
  });

  @override
  State<DashboardPasienView> createState() => _DashboardPasienViewState();
}

class _DashboardPasienViewState extends State<DashboardPasienView> {
  final DashboardPasienController _con = DashboardPasienController();

  Widget _ambilHalaman(int index) {
    switch (index) {
      case 0:
        return BerandaPasienView(username: widget.username);
      case 1:
        return RiwayatPasienView(username: widget.username);
      case 2:
        return ProfilPasienView(username: widget.username);
      default:
        return BerandaPasienView(username: widget.username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF9FAFB), // Warna background abu-abu sangat muda
      body: ValueListenableBuilder<int>(
        valueListenable: _con.currentIndex,
        builder: (context, index, child) {
          return _ambilHalaman(index);
        },
      ),
      resizeToAvoidBottomInset: false,

      // Menggunakan Custom Bottom Bar yang sama dengan Role Nakes
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _con.currentIndex,
        builder: (context, index, child) {
          return CustomBottomBarPasien(
            currentIndex: index,
            onTap: _con.gantiTab,
          );
        },
      ),
    );
  }
}
