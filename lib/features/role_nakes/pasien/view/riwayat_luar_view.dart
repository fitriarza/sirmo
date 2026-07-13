import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sirmo_app/core/network/api_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/riwayat_luar_controller.dart';

class RiwayatLuarView extends StatefulWidget {
  final Map<String, dynamic> pasien;
  final String usernameNakes;

  const RiwayatLuarView({
    super.key,
    required this.pasien,
    required this.usernameNakes,
  });

  @override
  State<RiwayatLuarView> createState() => _RiwayatLuarViewState();
}

class _RiwayatLuarViewState extends State<RiwayatLuarView> {
  final RiwayatLuarController _con = RiwayatLuarController();

  @override
  void initState() {
    super.initState();
    _muatDataDanFetch();
  }

  Future<Map<String, dynamic>> getDetailNakes(String username) async {
  try {
    // Memanggil API get_profil_nakes.php untuk mendapatkan id_klinik nakes
    var url = Uri.parse(ApiConstants.getProfilNakes); 
    var response = await http.post(url, body: {'username': username});

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Mengecek apakah data berhasil diambil (sesuai format PHP kamu)
      if (data['sukses'] == true) { 
        return Map<String, dynamic>.from(data['data']);
      }
    }
  } catch (e) {
    debugPrint("Error ambil profil nakes: $e");
  }
  // Return default kalau gagal agar tidak crash
  return {'id_klinik': '0'}; 
}
  Future<void> _muatDataDanFetch() async {
    String idPasien = widget.pasien['id_pasien']?.toString() ?? '0';

    // 1. Panggil API untuk tahu Nakes ini ID Kliniknya berapa
    var dataNakes = await _con.getDetailNakes(widget.usernameNakes);

    // 2. Ambil ID Klinik dari data tersebut
    String idKlinikLogin = dataNakes['id_klinik'].toString();

    // 3. Baru fetch riwayat
    _con.fetchRiwayatLuar(idPasien, idKlinikLogin);
  }

  // 🟢 FUNGSI UNTUK MEMUNCULKAN DETAIL SAAT DIKLIK
  void _showDetailBottomSheet(
    BuildContext context,
    Map<String, dynamic> data,
    bool isMandiri,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(
                  isMandiri
                      ? 'Detail Riwayat Mandiri'
                      : 'Detail Riwayat Klinik Lain',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textUtama,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Tanggal', data['tanggal'] ?? '-'),
                _buildDetailRow(
                  isMandiri ? 'Keluhan Awal' : 'Diagnosa',
                  data['diagnosa'] ?? '-',
                ),
                _buildDetailRow(
                  isMandiri ? 'Obat yang Diminum' : 'Keluhan Pasien',
                  (data['keluhan_atau_obat'] ?? '-')
                      .replaceAll('Keluhan: ', '')
                      .replaceAll('Obat Diminum: ', ''),
                ),

                // ... di dalam _showDetailBottomSheet setelah bagian 'Solusi / Catatan Dokter'
                if (!isMandiri) ...[
                  _buildDetailRow(
                    'Hasil Pemeriksaan',
                    data['hasil_periksa'] ?? '-',
                  ),
                  _buildDetailRow(
                    'Solusi / Catatan Dokter',
                    data['solusi_catatan'] ?? '-',
                  ),
                  // 🟢 TAMPILKAN DAFTAR OBAT DI SINI
                  _buildDetailRow(
                    'Obat yang Diberikan',
                    data['daftar_obat'] != null &&
                            data['daftar_obat'].isNotEmpty
                        ? data['daftar_obat']
                        : 'Tidak ada obat yang diberikan',
                  ),
                ],

                // ...
                _buildDetailRow('Ditangani Oleh', data['nama_dokter'] ?? '-'),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.medisPrimary,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🟢 WIDGET BANTUAN UNTUK BARIS DETAIL
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _con.isLoading,
      builder: (context, loading, child) {
        if (loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.medisPrimary),
          );
        }

        if (_con.listRiwayat.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada riwayat pengobatan luar/mandiri.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _con.listRiwayat.length,
          itemBuilder: (context, index) {
            final data = _con.listRiwayat[index];
            bool isMandiri = data['sumber'] == 'Mandiri';

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              // 🟢 DITAMBAHKAN INKWELL AGAR BISA DIKLIK
              child: InkWell(
                onTap: () => _showDetailBottomSheet(context, data, isMandiri),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        isMandiri ? Colors.orange.shade50 : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isMandiri
                              ? Colors.orange.shade200
                              : Colors.blue.shade200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isMandiri
                                      ? Colors.orange
                                      : Colors.blue.shade600,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isMandiri ? 'Obat Mandiri' : 'Klinik Lain',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            data['tanggal'] ?? '-',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textUtama,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data['diagnosa'] ?? '-',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:
                              isMandiri
                                  ? Colors.orange.shade900
                                  : Colors.blue.shade900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['keluhan_atau_obat'] ?? '-',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSekunder,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(height: 1, color: Colors.black12),
                      ),
                      Row(
                        children: [
                          Icon(
                            isMandiri
                                ? Icons.medical_services_rounded
                                : Icons.local_hospital_rounded,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Oleh: ${data['nama_dokter']}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade700,
                                fontStyle: FontStyle.italic,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
