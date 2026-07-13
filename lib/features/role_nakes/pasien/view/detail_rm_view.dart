import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'cetak_surat_view.dart'; // 🟢 IMPORT FILE PDF KITA

class DetailRmView extends StatelessWidget {
  final Map<String, dynamic> riwayat;
  final Map<String, dynamic> pasien;

  const DetailRmView({super.key, required this.riwayat, required this.pasien});

  @override
  Widget build(BuildContext context) {
    // 🟢 1. EKSTRAK DATA
    final String namaDokter = riwayat['nama_dokter'] ?? 'Tenaga Medis';
    final String tglLengkap = riwayat['tgl_periksa_lengkap'] ?? '${riwayat['tanggal']} ${riwayat['jam']}';
    final String keluhan = riwayat['keluhan'] ?? '-';
    final String diagnosa = riwayat['diagnosa'] ?? '-';
    final List<dynamic> listResep = riwayat['resep'] ?? [];

    String teksHasil = riwayat['hasil_periksa'] ?? 'Tensi: -, Suhu: -';
    List<String> vitalSign = teksHasil.split(', ');
    String tensi = vitalSign.isNotEmpty ? vitalSign[0].replaceAll('Tensi:', '').trim() : '-';
    String suhu = vitalSign.length > 1 ? vitalSign[1].replaceAll('Suhu:', '').trim() : '-';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detail Rekam Medis', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textUtama)),
            Text('ID Kunjungan: #RM-${riwayat['id_rm'] ?? '000'}', style: const TextStyle(fontSize: 10, color: AppColors.textSekunder)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textUtama, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // KARTU ATAS
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('PASIEN', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                        Text('${pasien['nama_lengkap']} (${pasien['jenis_kelamin'] == 'Laki-laki' ? 'L' : 'P'})', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('TANGGAL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                        Text(tglLengkap, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(color: Colors.black12)),
                Row(
                  children: [
                    Container(width: 24, height: 24, decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle), child: const Icon(Icons.medical_services_rounded, size: 14, color: AppColors.medisPrimary)),
                    const SizedBox(width: 8),
                    Text('$namaDokter (Tenaga Medis)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textUtama)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          // DATA KLINIS
          const Text('DATA KLINIS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: _buildInfoBox('Tekanan Darah', tensi)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildInfoBox('Suhu Tubuh', suhu)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Anamnesa (Keluhan)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textUtama)),
                Container(width: double.infinity, padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(6)), child: Text(keluhan, style: const TextStyle(fontSize: 12))),
                const SizedBox(height: 16),
                const Text('Diagnosa Utama', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textUtama)),
                Text(diagnosa, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // RESEP
          const Text('RESEP & TINDAKAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
            child: listResep.isEmpty
                ? const Padding(padding: EdgeInsets.all(16), child: Text('Tidak ada resep.', style: TextStyle(fontSize: 12, color: Colors.grey)))
                : DataTable(
                    headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
                    columns: const [DataColumn(label: Text('Nama Obat', style: TextStyle(fontSize: 12))), DataColumn(label: Text('Aturan', style: TextStyle(fontSize: 12)))],
                    rows: listResep.map((obat) => DataRow(cells: [
                      DataCell(Text(obat['nama_obat'] ?? '-', style: const TextStyle(fontSize: 12))), 
                      // 🟢 MENDUKUNG KOLOM DOSIS ATAU ATURAN PAKAI
                      DataCell(Text(obat['dosis'] ?? obat['aturan_pakai'] ?? '-', style: const TextStyle(fontSize: 12)))
                    ])).toList(),
                  ),
          ),
          const SizedBox(height: 24),

          // 🟢 TOMBOL CETAK (MUNCUL JIKA ADA DATA SURAT)
          if (riwayat['surat_sakit'] == '1')
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(vertical: 12)),
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              label: const Text('CETAK SURAT SAKIT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CetakSuratView(
                  data: {
                    // 🟢 Paket data super komplit & dinamis (dengan ban serep netral)
                    'nama_pasien': pasien['nama_lengkap'] ?? 'Tanpa Nama',
                    'nama_dokter': namaDokter,
                    'tanggal': riwayat['tanggal'] ?? '-',
                    'diagnosa': riwayat['diagnosa'] ?? '-',
                    'lama_istirahat': riwayat['lama_istirahat'] ?? '3 Hari',
                    'nama_klinik': riwayat['nama_klinik'] ?? 'Nama Klinik Tidak Tersedia',
                    'alamat_klinik': riwayat['alamat_klinik'] ?? 'Alamat Belum Diatur',
                    'kota_klinik': riwayat['kota_klinik'] ?? '-',
                  },
                )));
              },
            ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(title, style: const TextStyle(fontSize: 9, color: Colors.grey)), Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))],
      ),
    );
  }
}