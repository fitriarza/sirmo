import 'package:flutter/material.dart';
import '../controllers/super_admin_dashboard_controller.dart';

class SuperAdminDashboardView extends StatefulWidget {
  const SuperAdminDashboardView({super.key});

  @override
  State<SuperAdminDashboardView> createState() =>
      _SuperAdminDashboardViewState();
}

class _SuperAdminDashboardViewState extends State<SuperAdminDashboardView> {
  final SuperAdminDashboardController _controller =
      SuperAdminDashboardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _controller.getDataDashboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Data tidak tersedia'));
          }

          final data = snapshot.data!;

          return Column(
            children: [
              // HEADER TETAP SAMA
              Container(
                padding: EdgeInsets.fromLTRB(
                  24,
                  MediaQuery.of(context).padding.top + 24,
                  24,
                  24,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                          ),
                        ),
                        Text(
                          'Selamat datang, Super Admin',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Color(0xFF4F46E5),
                      size: 30,
                    ),
                  ],
                ),
              ),

              // KONTEN UTAMA
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    // 1. KPI CARDS
                    Row(
                      children: [
                        _kpiCard(
                          'Total Klinik',
                          data['total_klinik'].toString(),
                          Icons.local_hospital_rounded,
                          const Color(0xFF4F46E5),
                          true,
                        ),
                        const SizedBox(width: 16),
                        _kpiCard(
                          'Total Nakes',
                          data['total_nakes'].toString(),
                          Icons.people_alt_rounded,
                          Colors.white,
                          false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 2. TINDAKAN MENDESAK
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _itemMendesak(
                            'Klinik Perlu Verifikasi',
                            '${data['klinik_pending']} Pending',
                            Colors.amber,
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: Colors.white10, height: 1),
                          const SizedBox(height: 16),
                          _itemMendesak(
                            'Nakes Baru Daftar',
                            '${data['nakes_pending']} Antrean',
                            Colors.blue,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. TREN PERTUMBUHAN BULANAN
                    const Text(
                      'TREN PERTUMBUHAN BULANAN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        children: [
                          _barProgress(
                            'Klinik Aktif',
                            ((data['total_klinik'] as num) / 100)
                                .clamp(0.0, 1.0)
                                .toDouble(),
                            '${data['total_klinik']} Klinik',
                            const Color(0xFF4F46E5),
                          ),
                          const SizedBox(height: 20),
                          _barProgress(
                            'Nakes Terdaftar',
                            ((data['total_nakes'] as num) / 200)
                                .clamp(0.0, 1.0)
                                .toDouble(),
                            '${data['total_nakes']} Nakes',
                            Colors.teal,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. LOG TERKINI
                    const Text(
                      'LOG TERKINI',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder<String>(
                      future: _controller.getLatestLog(),
                      builder: (context, snapshot) {
                        String namaKlinik = snapshot.data ?? "Memuat...";
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF4B5563),
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Klinik Baru: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF111827),
                                        ),
                                      ),
                                      TextSpan(
                                        text: '$namaKlinik telah mendaftar.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _kpiCard(
    String label,
    String val,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color:
                  isDark
                      ? Colors.white.withOpacity(0.7)
                      : const Color(0xFF4F46E5),
            ),
            const SizedBox(height: 8),
            Text(
              val,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white54 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemMendesak(String title, String subtitle, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            subtitle,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _barProgress(String title, double val, String delta, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              delta,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: val,
          backgroundColor: Colors.grey.shade100,
          valueColor: AlwaysStoppedAnimation(color),
          minHeight: 8,
        ),
      ],
    );
  }
}
