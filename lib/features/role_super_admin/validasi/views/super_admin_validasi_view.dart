import 'package:flutter/material.dart';
import 'package:sirmo_app/features/role_super_admin/validasi/controllers/super_admin_validasi_controller.dart';
import 'package:url_launcher/url_launcher.dart'; // 🟢 WAJIB ADA BUAT BUKA LINK
import 'package:sirmo_app/core/network/api_constants.dart'; // 🟢 WAJIB ADA BUAT AMBIL BASE URL

class SuperAdminValidasiView extends StatefulWidget {
  const SuperAdminValidasiView({super.key});

  @override
  State<SuperAdminValidasiView> createState() => _SuperAdminValidasiViewState();
}

class _SuperAdminValidasiViewState extends State<SuperAdminValidasiView> {
  final SuperAdminValidasiController _validasiController =
      SuperAdminValidasiController();

  // 🟢 FUNGSI _prosesAksi YANG SUDAH DIPERBARUI
  // 泙 FUNGSI _prosesAksi YANG SUDAH DIPERBARUI
  void _prosesAksi(String tipe, String id, String aksi) async {
    bool sukses = false;

    // --- LOGIKA UNTUK NAKES ---
    if (tipe == 'nakes') {
      if (aksi == 'Setujui') {
        sukses = await _validasiController.setujuiNakes(id);
      } else if (aksi == 'Tolak') {
        sukses = await _validasiController.prosesValidasi(tipe, id, aksi);
      }
    } 
    // --- LOGIKA UNTUK KLINIK BARU DITAMBAHKAN ---
    else if (tipe == 'klinik') {
      // Entah itu Setujui atau Tolak, kita panggil fungsi prosesValidasi
      // Karena fungsi ini akan mengirimkan nilai 'aksi' (Setujui/Tolak) ke PHP
      sukses = await _validasiController.prosesValidasi(tipe, id, aksi);
    } 
    else {
      debugPrint("Logika untuk $tipe - $aksi belum dibuat.");
    }

    if (sukses) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$aksi berhasil diproses!'),
            backgroundColor: aksi == 'Setujui' ? Colors.green : Colors.red,
          ),
        );
        setState(() {}); // Refresh data supaya yang di-klik hilang dari daftar
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan saat memproses!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 🟢 Menampilkan Pop-up Review Berkas
  void _showReviewModal(
    BuildContext context,
    Map<String, dynamic> data,
    String tipe,
  ) {
    // Menentukan variabel berdasarkan tipe (nakes / klinik)
    final String judul =
        tipe == 'nakes' ? data['nama_lengkap'] : data['nama_klinik'];
    final String idUnik =
        tipe == 'nakes'
            ? data['id_user'].toString()
            : data['id_klinik'].toString();
    final String info1 =
        tipe == 'nakes'
            ? 'Nomor STR: ${data['nip_str']}'
            : 'Nama Owner: ${data['nama_owner']}';
    final String info2 =
        tipe == 'nakes'
            ? 'Tujuan: ${data['nama_klinik']}'
            : 'Tipe: Registrasi Klinik Baru';
    final String namaFile =
        tipe == 'nakes'
            ? (data['file_str'] ?? 'Tidak ada file')
            : (data['file_izin'] ?? 'Tidak ada file');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return Container(
          height:
              MediaQuery.of(context).size.height * 0.85, // Mengisi 85% layar
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Modal
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Review Berkas',
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
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    // PREVIEW DOKUMEN 
                    const Text(
                      'Dokumen Lampiran',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        // Tentukan folder berdasarkan tipe
                        final String folder =
                            tipe == 'nakes' ? 'str' : 'izin_klinik';
                        
                        // PERBAIKAN 1: Gunakan Uri.encodeFull agar spasi menjadi %20
                        final String rawUrl = '${ApiConstants.baseUrl}uploads/$folder/$namaFile';
                        final Uri url = Uri.parse(Uri.encodeFull(rawUrl));

                        // PERBAIKAN 2: Langsung jalankan launchUrl (tanpa canLaunchUrl)
                        try {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (e) {
                          if (modalContext.mounted) {
                            ScaffoldMessenger.of(modalContext).showSnackBar(
                              const SnackBar(
                                content: Text("Gagal membuka dokumen!"),
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.open_in_new_rounded,
                              color: Colors.blue,
                              size: 32,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Klik di sini untuk melihat\nDokumen Lampiran",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "(Akan terbuka di browser/aplikasi lain)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Detail Biodata
                    const Text(
                      'Data Identitas',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
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
                            judul,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.badge_outlined,
                                size: 16,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                info1,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                info2,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol Eksekusi di Bawah
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(modalContext); // Tutup modal dulu
                          _prosesAksi(
                            tipe,
                            idUnik,
                            'Tolak',
                          ); // Lalu eksekusi tolak
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Tolak Berkas',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(modalContext); // Tutup modal dulu
                          
                          // Langsung panggil fungsi sakti kita!
                          // Dia otomatis tahu ini 'nakes' atau 'klinik' dari variabel tipe
                          _prosesAksi(tipe, idUnik, 'Setujui'); 
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Setujui & Aktifkan',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<dynamic>>>(
      future: _validasiController.getDataValidasi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFF9FAFB),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
            ),
          );
        }

        final dataNakes = snapshot.data?['nakes'] ?? [];
        final dataKlinik = snapshot.data?['klinik'] ?? [];

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              titleSpacing: 24,
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pusat Verifikasi',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              bottom: TabBar(
                labelColor: const Color(0xFF4F46E5),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF4F46E5),
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(text: 'Nakes (${dataNakes.length})'),
                  Tab(text: 'Klinik (${dataKlinik.length})'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // TAB 1: NAKES
                dataNakes.isEmpty
                    ? Center(
                      child: Text(
                        'Tidak ada antrean Nakes',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: dataNakes.length,
                      itemBuilder: (context, index) {
                        final nakes = dataNakes[index];
                        return _buildVerifikasiCard(
                          ikon: Icons.person_rounded,
                          warnaIkon: Colors.blue,
                          judul: nakes['nama_lengkap'],
                          subJudul:
                              'STR: ${nakes['nip_str']}\nTujuan: ${nakes['nama_klinik']}',
                          onReviewTap:
                              () => _showReviewModal(context, nakes, 'nakes'),
                        );
                      },
                    ),

                // TAB 2: KLINIK
                dataKlinik.isEmpty
                    ? Center(
                      child: Text(
                        'Tidak ada antrean Klinik Baru',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: dataKlinik.length,
                      itemBuilder: (context, index) {
                        final klinik = dataKlinik[index];
                        return _buildVerifikasiCard(
                          ikon: Icons.local_hospital_rounded,
                          warnaIkon: Colors.amber.shade600,
                          judul: klinik['nama_klinik'],
                          subJudul: 'Pemilik: ${klinik['nama_owner']}',
                          onReviewTap:
                              () => _showReviewModal(context, klinik, 'klinik'),
                        );
                      },
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  // DESAIN CARD BARU 
  Widget _buildVerifikasiCard({
    required IconData ikon,
    required Color warnaIkon,
    required String judul,
    required String subJudul,
    required VoidCallback onReviewTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: warnaIkon.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(ikon, color: warnaIkon, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subJudul,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onReviewTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(
                0xFF111827,
              ), // Warna hitam pekat elegan
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
            child: const Text(
              'Review',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}