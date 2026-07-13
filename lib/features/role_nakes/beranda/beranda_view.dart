import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'beranda_controller.dart';

class BerandaView extends StatelessWidget {
  final String username;
  BerandaView({super.key, required this.username});

  final BerandaController _con = BerandaController();

  final List<Map<String, int>> _warnaPenyakit = [
    {'bg': 0xFFFEE2E2, 'text': 0xFFDC2626},
    {'bg': 0xFFFEF3C7, 'text': 0xFFD97706},
    {'bg': 0xFFDBEAFE, 'text': 0xFF2563EB},
    {'bg': 0xFFD1FAE5, 'text': 0xFF059669},
    {'bg': 0xFFF3E8FF, 'text': 0xFF7E22CE},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // --- HEADER GRADIENT ---
          Container(
            padding: const EdgeInsets.only(
              top: 48,
              left: 20,
              right: 20,
              bottom: 24,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.medical_services_outlined,
                            color: Colors.white,
                            size: 10,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'TENAGA MEDIS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.badge_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),

          // --- BODY DENGAN FUTURE BUILDER ---
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _con.fetchDashboardStats(username),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.medisPrimary,
                    ),
                  );
                }

                final data =
                    snapshot.data ??
                    {
                      'pasienHariIni': 0,
                      'totalPasien': 0,
                      'totalObat': 0,
                      'listPenyakit': [],
                      'listObat': [],
                      'grafik': [0, 0, 0, 0, 0, 0, 0],
                    };

                final listPenyakit =
                    data['listPenyakit'] as List<dynamic>? ?? [];
                final listObat = data['listObat'] as List<dynamic>? ?? [];
                final grafikData =
                    data['grafik'] as List<int>? ?? [0, 0, 0, 0, 0, 0, 0];

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // 1. KARTU COUNTER
                    Row(
                      children: [
                        Expanded(
                          child: _buildCounterCard(
                            'Total Kunjungan RM',
                            '${data['pasienHariIni'] ?? 0}',
                            'Berkas',
                            const Color(0xFFECFDF5),
                            const Color(0xFF059669),
                            Icons.folder_shared_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCounterCard(
                            'Total Pasien',
                            '${data['totalPasien'] ?? 0}',
                            'Orang',
                            const Color(0xFFF0FDFA),
                            const Color(0xFF0D9488),
                            Icons.people_alt_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 2. GRAFIK KUNJUNGAN REAL MINGGU INI
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusBesar,
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'STATISTIK KUNJUNGAN',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textUtama,
                                ),
                              ),
                              Text(
                                'Minggu Ini',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSekunder,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Builder(
                            builder: (context) {
                              int maxVal = 1;
                              for (var v in grafikData) {
                                if (v > maxVal) maxVal = v;
                              }

                              return SizedBox(
                                height: 80,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children:
                                      grafikData.map((nilai) {
                                        double tinggi = (nilai / maxVal) * 80.0;
                                        if (nilai == 0) tinggi = 4.0;

                                        bool isMax =
                                            nilai == maxVal && maxVal > 1;

                                        return Tooltip(
                                          message: '$nilai Kunjungan',
                                          child: Container(
                                            width: 16,
                                            height: tinggi,
                                            decoration: BoxDecoration(
                                              color:
                                                  isMax
                                                      ? AppColors.medisPrimary
                                                      : AppColors.medisPrimary
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Sen',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textSekunder,
                                ),
                              ),
                              Text(
                                'Sel',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textSekunder,
                                ),
                              ),
                              Text(
                                'Rab',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textSekunder,
                                ),
                              ),
                              Text(
                                'Kam',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textSekunder,
                                ),
                              ),
                              Text(
                                'Jum',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textSekunder,
                                ),
                              ),
                              Text(
                                'Sab',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textSekunder,
                                ),
                              ),
                              Text(
                                'Min',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textSekunder,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. RANKING 5 PENYAKIT TERBANYAK
                    const Text(
                      '5 PENYAKIT TERBANYAK',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSekunder,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusBesar,
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child:
                          (listPenyakit.isEmpty)
                              ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: Text(
                                    "Belum ada data diagnosa",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              )
                              : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: listPenyakit.length,
                                separatorBuilder:
                                    (context, index) => const Divider(
                                      color: AppColors.background,
                                      height: 1,
                                    ),
                                itemBuilder: (context, index) {
                                  final item = listPenyakit[index];
                                  final warna =
                                      _warnaPenyakit[index %
                                          _warnaPenyakit.length];

                                  // 🟢 AMAN: Pakai ?? '-' atau ?? '0' untuk semua akses data
                                  final String namaP =
                                      (item['diagnosa'] ?? 'Tidak Diketahui')
                                          .toString();
                                  final String jmlP =
                                      (item['jumlah'] ?? 0).toString();

                                  return ListTile(
                                    dense: true,
                                    leading: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Color(warna['bg']!),
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Color(warna['text']!),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      namaP,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textUtama,
                                      ),
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                      child: Text(
                                        jmlP,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textUtama,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                    const SizedBox(height: 16),

                    // 4. TABEL OBAT SERING DIGUNAKAN
                    const Text(
                      'OBAT SERING DIGUNAKAN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSekunder,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusBesar,
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child:
                          listObat.isEmpty
                              ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: Text(
                                    "Belum ada resep tercatat",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              )
                              : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: listObat.length,
                                separatorBuilder:
                                    (context, index) => const Divider(
                                      color: AppColors.background,
                                      height: 1,
                                    ),
                                itemBuilder: (context, index) {
                                  final obat = listObat[index];

                                  // Definisi variabel yang benar
                                  final String namaO =
                                      (obat['nama_obat'] ?? 'Obat Tanpa Nama')
                                          .toString();
                                  final String jmlO =
                                      (obat['jumlah'] ?? 0).toString();

                                  return ListTile(
                                    dense: true,
                                    leading: const Icon(
                                      Icons.medication_rounded,
                                      color: AppColors.medisPrimary,
                                      size: 20,
                                    ),
                                    // 🟢 PAKAI VARIABEL namaO DI SINI
                                    title: Text(
                                      namaO,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textUtama,
                                      ),
                                    ),
                                    // 🟢 PAKAI VARIABEL jmlO DI SINI
                                    trailing: Text(
                                      '$jmlO x',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.medisPrimary,
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterCard(
    String title,
    String count,
    String unit,
    Color bg,
    Color textCol,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSizes.radiusBesar),
        border: Border.all(color: textCol.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textCol, size: 18),
          const SizedBox(height: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: textCol,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                count,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textUtama,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSekunder,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
