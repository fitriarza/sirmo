import 'package:flutter/material.dart';
import '../controllers/riwayat_pasien_controller.dart';
import '../../input_mandiri/views/input_mandiri_view.dart';
import '../views/detail_rm_pasien_view.dart';
import '../views/detail_mandiri_view.dart';

class RiwayatPasienView extends StatefulWidget {
  final String username;
  const RiwayatPasienView({super.key, required this.username});

  @override
  State<RiwayatPasienView> createState() => _RiwayatPasienViewState();
}

class _RiwayatPasienViewState extends State<RiwayatPasienView> {
  final RiwayatPasienController _con = RiwayatPasienController();

  @override
  void initState() {
    super.initState();
    // 🟢 SEDOT DATA OTOMATIS PAS HALAMAN DIBUKA!
    _con.fetchRiwayat(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Stack(
        children: [
          Column(
            children: [
              // --- HEADER ATAS ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    top: 50, left: 20, right: 20, bottom: 20),
                color: const Color(0xFF111827),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Riwayat Kesehatan',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: 4),
                    Text('Rekap Kunjungan & Pengobatan',
                        style: TextStyle(fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ),

              // --- TAB BAR CUSTOM ---
              ValueListenableBuilder<int>(
                valueListenable: _con.activeTab,
                builder: (context, activeIndex, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Row(
                      children: [
                        _buildTabItem('Semua', 0, activeIndex),
                        _buildTabItem('Dari Dokter', 1, activeIndex),
                        _buildTabItem('Mandiri', 2, activeIndex),
                      ],
                    ),
                  );
                },
              ),

              // --- SCROLLABLE CONTENT ---
              Expanded(
                  child: ValueListenableBuilder<bool>(
                      valueListenable: _con.isLoading,
                      builder: (context, loading, child) {
                        if (loading) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xFF111827)));
                        }

                        return ValueListenableBuilder<int>(
                          valueListenable: _con.activeTab,
                          builder: (context, activeIndex, child) {
                            final listData = _con.getListSesuaiTab(activeIndex);

                            return ListView(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 80),
                              children: [
                                // KOTAK TOTAL KUNJUNGAN (Hanya muncul di tab Dokter/Semua)
                                if (activeIndex != 2)
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.blue.shade50,
                                                  shape: BoxShape.circle),
                                              child: Icon(
                                                  Icons
                                                      .medical_services_rounded,
                                                  color: Colors.blue.shade600,
                                                  size: 20),
                                            ),
                                            const SizedBox(width: 12),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text('Total Kunjungan',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    '${_con.riwayatDokter.length}x',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Text('Terakhir',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey)),
                                            Text(
                                                _con.riwayatDokter.isNotEmpty
                                                    ? _con.riwayatDokter
                                                        .first['tanggal']
                                                    : '-',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                // INFORMASI PRIVASI (Hanya muncul di tab Mandiri)
                                if (activeIndex == 2)
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.blue.shade100),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.info_outline_rounded,
                                            color: Colors.blue.shade600,
                                            size: 16),
                                        const SizedBox(width: 8),
                                        const Expanded(
                                          child: Text(
                                            'Data ini diinput oleh Anda sendiri. Dokter tidak dapat melihat Riwayat Mandiri Anda tanpa seizin Anda melalui Kode Akses.',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black87,
                                                height: 1.4),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                // LIST RIWAYAT CARD
                                ...listData
                                    .map((data) => _buildRiwayatCard(data)),
                                    

                                if (listData.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 40),
                                    child: Center(
                                        child: Text(
                                            'Belum ada riwayat tercatat di database.',
                                            style:
                                                TextStyle(color: Colors.grey))),
                                  )
                              ],
                            );
                          },
                        );
                      }))
            ],
          ),

          // TOMBOL MELAYANG (+) HANYA MUNCUL DI TAB MANDIRI (INDEX 2)
          ValueListenableBuilder<int>(
            valueListenable: _con.activeTab,
            builder: (context, activeIndex, child) {
              if (activeIndex != 2) return const SizedBox.shrink();

              return Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () async {
                    // 🟢 Ganti '' dengan widget.username
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InputMandiriView(username: widget.username),
                      ),
                    );

                    // Refresh setelah balik dari input
                    if (result == true) {
                      _con.fetchRiwayat(widget.username);
                    }
                  },
                  backgroundColor: const Color(0xFF111827),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.add_rounded,
                      color: Colors.white, size: 28),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // WIDGET PEMBANTU: TAB ITEM
  Widget _buildTabItem(String title, int index, int activeIndex) {
    final bool isActive = activeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _con.gantiTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isActive ? const Color(0xFF111827) : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? const Color(0xFF111827) : Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }

  // WIDGET PEMBANTU: CARD RIWAYAT
  // WIDGET PEMBANTU: CARD RIWAYAT
  Widget _buildRiwayatCard(Map<String, dynamic> data) {
    bool isDokter = data['tipe'] == 'dokter';

    // 🟢 BUNGKUS DENGAN INKWELL DI SINI
    return InkWell(
      // 🟢 KODE BARU (KODE DETEKTIF)
      onTap: () {
        if (isDokter) {
          // Cek apakah id_rm benar-benar ada isinya
          if (data['id_rm'] != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailRmPasienView(idRm: data['id_rm'].toString()),
              ),
            );
          } else {
            // 🚨 KALAU KOSONG, MUNCULKAN PESAN MERAH INI DI HP!
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('GAGAL BUKA: id_rm dari database KOSONG / NULL!'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        } else if (!isDokter) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailMandiriView(data: data),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(16), // Biar efek kliknya ngikutin bentuk kotak
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2))
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge & Tanggal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDokter ? Colors.blue.shade50 : Colors.orange.shade50,
                        border: Border.all(
                            color: isDokter ? Colors.blue.shade100 : Colors.orange.shade100),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                              isDokter
                                  ? Icons.vaccines_rounded
                                  : Icons.edit_document,
                              size: 12,
                              color: isDokter ? Colors.blue.shade700 : Colors.orange.shade700),
                          const SizedBox(width: 4),
                          Text(
                            isDokter ? 'Dari Klinik' : 'Obat Warung / Mandiri',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDokter ? Colors.blue.shade700 : Colors.orange.shade700),
                          ),
                        ],
                      ),
                    ),
                    Text(data['tanggal'],
                        style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 12),

                // Diagnosa & Pemeriksa
                Text(data['diagnosa'],
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 4),
                Text(
                    isDokter
                        ? 'Ditangani oleh: ${data['pemeriksa']}'
                        : 'Tindakan: ${data['pemeriksa']}',
                    style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 12),

                // Garis Pembatas
                Divider(color: Colors.grey.shade100, height: 1),
                const SizedBox(height: 12),

                // List Obat
                Text(isDokter ? 'Resep Obat:' : 'Obat yang dikonsumsi:',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
                const SizedBox(height: 6),
                ...data['obat']
                    .map<Widget>((obat) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  color: Colors.green, size: 12),
                              const SizedBox(width: 6),
                              Text(obat,
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.black87)),
                            ],
                          ),
                        ))
                    .toList(),
              ],
            ),
            
            // 🟢 Icon Panah Kanan cuma muncul kalau dia dari Dokter (bisa diklik)
            if (isDokter)
              const Positioned(
                right: 0,
                top: 24,
                child: Icon(Icons.chevron_right_rounded, color: Colors.grey),
              )
          ],
        ),
      ),
    );
  }
}