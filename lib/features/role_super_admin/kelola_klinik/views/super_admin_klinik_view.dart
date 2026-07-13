// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import '../controllers/super_admin_klinik_controller.dart';
import 'package:intl/intl.dart'; // 🟢 WAJIB ADA untuk format tanggal

class SuperAdminKlinikView extends StatefulWidget {
  const SuperAdminKlinikView({super.key});

  @override
  State<SuperAdminKlinikView> createState() => _SuperAdminKlinikViewState();
}

class _SuperAdminKlinikViewState extends State<SuperAdminKlinikView> {
  final SuperAdminKlinikController _klinikController =
      SuperAdminKlinikController();

  // Fungsi memformat tanggal (YYYY-MM-DD ke DD-MM-YYYY)
  String _formatTanggal(String? tanggalRaw) {
    if (tanggalRaw == null || tanggalRaw.isEmpty) return 'Tidak diketahui';
    try {
      DateTime dt = DateTime.parse(tanggalRaw);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (e) {
      return tanggalRaw;
    }
  }

  // 🟢 FUNGSI BARU: Bottom Sheet untuk Detail & Aksi
  void _showDetailKlinik(
    BuildContext context,
    Map<String, dynamic> klinik,
    bool isAktif,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Detail & Kendali Klinik',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(modalContext),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Info Identitas
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      klinik['nama_klinik'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.person_rounded,
                      'Owner',
                      klinik['nama_owner'],
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.phone_rounded,
                      'No. Telp',
                      klinik['no_telp'],
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.location_on_rounded,
                      'Alamat',
                      klinik['alamat'],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Info Statistik Nakes
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.medical_services_rounded,
                      color: Colors.blue.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tenaga Medis (Nakes)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Terdaftar di klinik ini',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${klinik['jumlah_nakes'] ?? 0} Orang',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Tombol Aksi
              const Text(
                'Aksi Pengendalian',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              // --- TOMBOL RESET PASSWORD ---
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    Navigator.pop(modalContext); // Tutup modal dulu

                    // Tampilkan loading manual pakai SnackBar sementara API berjalan
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Memproses reset password...'),
                      ),
                    );

                    final result = await _klinikController.prosesAksiKlinik(
                      klinik['id_klinik'].toString(),
                      'reset_password',
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result['message']),
                          backgroundColor:
                              result['sukses'] ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.vpn_key_rounded, size: 16),
                  label: const Text(
                    'Reset Password Klinik',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF111827),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // --- TOMBOL AKTIFKAN / BLOKIR ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(modalContext); // Tutup modal dulu

                    final result = await _klinikController.prosesAksiKlinik(
                      klinik['id_klinik'].toString(),
                      'toggle_status',
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result['message']),
                          backgroundColor:
                              result['sukses'] ? Colors.green : Colors.red,
                        ),
                      );
                      // 🟢 REFRESH LAYAR BIAR STATUSNYA BERUBAH
                      if (result['sukses']) {
                        setState(() {});
                      }
                    }
                  },
                  icon: Icon(
                    isAktif
                        ? Icons.block_rounded
                        : Icons.check_circle_outline_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    isAktif
                        ? 'Blokir / Nonaktifkan Klinik'
                        : 'Aktifkan Kembali',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isAktif ? Colors.red.shade600 : Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF4B5563),
                fontFamily: 'Inter',
              ),
              children: [
                TextSpan(text: '$title: '),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          // HEADER & PENCARIAN
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data Klinik',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Pusat kendali operasional klinik',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.grey.shade400,
                          size: 16,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Cari ID atau Nama Klinik...',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LIST KLINIK DINAMIS DARI DATABASE
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _klinikController.getDaftarKlinik(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
                  );
                }
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Belum ada data klinik yang aktif/diblokir.',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  );
                }

                final dataKlinik = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
                  itemCount: dataKlinik.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          'DAFTAR KLINIK TERDAFTAR',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 1.2,
                          ),
                        ),
                      );
                    }

                    final klinik = dataKlinik[index - 1];

                    String namaKlinik = klinik['nama_klinik'];
                    String inisial =
                        namaKlinik.length > 1
                            ? namaKlinik.substring(0, 2).toUpperCase()
                            : 'KL';
                    // 🟢 FIX 1: Pengecekan status menggunakan huruf kecil 'aktif'
                    bool isAktif = klinik['status'] == 'aktif';
                    // 🟢 FIX 2: Mengambil tanggal dari created_at
                    String tglGabung = _formatTanggal(klinik['created_at']);

                    return GestureDetector(
                      onTap: () => _showDetailKlinik(context, klinik, isAktif),
                      child: _buildKlinikCard(
                        inisial: inisial,
                        nama: namaKlinik,
                        owner: klinik['nama_owner'],
                        tglGabung: tglGabung,
                        isAktif:
                            isAktif, // Biar dia bisa bedain warna aktif vs diblokir
                        statusTeks:
                            klinik['status'], // Kirim status teks ke widget
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET CARD KLINIK YANG SUDAH DIRAPIKAN
  Widget _buildKlinikCard({
    required String inisial,
    required String nama,
    required String owner,
    required String tglGabung,
    required bool isAktif,
    required String statusTeks,
  }) {
    Widget cardContent = Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAktif ? Colors.white : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAktif ? Colors.grey.shade300 : Colors.grey.shade200,
        ),
        boxShadow: [
          if (isAktif)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Supaya logo di tengah
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isAktif ? Colors.blue.shade50 : Colors.grey.shade200,
              shape: BoxShape.circle,
              border: Border.all(
                color: isAktif ? Colors.blue.shade100 : Colors.grey.shade300,
              ),
            ),
            child: Center(
              child: Text(
                inisial,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isAktif ? Colors.blue.shade700 : Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:
                        isAktif ? Colors.grey.shade900 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Owner: $owner',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade400,
                      fontFamily: 'Inter',
                    ),
                    children: [
                      TextSpan(text: 'Gabung: $tglGabung • '),
                      TextSpan(
                        text:
                            statusTeks
                                .toUpperCase(), // Munculkan teks status aslinya
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              isAktif
                                  ? Colors.green.shade600
                                  : Colors.red.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Ikon panah kecil untuk menandakan bisa di-klik
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey.shade400,
            size: 20,
          ),
        ],
      ),
    );

    return isAktif ? cardContent : Opacity(opacity: 0.7, child: cardContent);
  }
}
