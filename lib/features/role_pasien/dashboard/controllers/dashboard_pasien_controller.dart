import 'package:flutter/material.dart';

class DashboardPasienController {
  // ValueNotifier untuk melacak tab mana yang sedang aktif. Default 0 (Beranda)
  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  // Fungsi untuk mengganti tab saat ditekan di CustomBottomBar
  void gantiTab(int index) {
    currentIndex.value = index;
  }
}