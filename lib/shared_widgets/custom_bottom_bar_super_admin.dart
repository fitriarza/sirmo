import 'package:flutter/material.dart';

class CustomBottomBarSuperAdmin extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBarSuperAdmin({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 🟢 4 TAB UTAMA SUPER ADMIN SESUAI MASTER PLAN
          _buildNavItem(icon: Icons.home_rounded, label: 'Dasbor', index: 0),
          _buildNavItem(icon: Icons.local_hospital_rounded, label: 'Klinik', index: 1),
          _buildNavItem(icon: Icons.how_to_reg_rounded, label: 'Validasi', index: 2), // Ikon user-check
          _buildNavItem(icon: Icons.settings_rounded, label: 'Lainnya', index: 3), // Ikon gear
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final bool isActive = currentIndex == index;
    
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? Colors.indigo.shade50 : Colors.transparent, // Efek hover background
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  icon, 
                  size: 20, 
                  color: isActive ? const Color(0xFF4F46E5) : Colors.grey.shade400 // Menggunakan warna Indigo khas desain modernmu
                ),
                const SizedBox(height: 2),
                Text(
                  label, 
                  style: TextStyle(
                    fontSize: 10, 
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal, 
                    color: isActive ? const Color(0xFF4F46E5) : Colors.grey.shade500
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}