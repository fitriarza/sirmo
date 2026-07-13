import 'package:flutter/material.dart';
import '../../../../shared_widgets/custom_bottom_bar.dart';
import '../beranda/beranda_view.dart';
import '../pasien/view/daftar_pasien_view.dart';
import '../profil/profil_nakes_view.dart';

class DashboardView extends StatefulWidget {
  final String username;
  const DashboardView({super.key, required this.username});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;

  Widget _ambilHalaman() {
    switch (_currentIndex) {
      case 0: 
        return BerandaView(username: widget.username);
      case 1: 
        return DaftarPasienView(usernameNakes: widget.username);
      case 2: 
        return ProfilNakesView(username: widget.username); // Menu Profil
      default: 
        return BerandaView(username: widget.username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ambilHalaman(),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CustomBottomBar(
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