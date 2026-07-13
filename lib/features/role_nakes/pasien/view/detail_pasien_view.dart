import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sirmo_app/core/network/api_constants.dart';
import 'dart:convert';
import '../../../../core/constants/app_colors.dart';
import '../controllers/detail_pasien_controller.dart';
import 'input_rekam_medis_view.dart';
import 'detail_rm_view.dart';
import 'riwayat_luar_view.dart';

class DetailPasienView extends StatefulWidget {
  final Map<String, dynamic> pasien;
  final String usernameNakes;

  const DetailPasienView({
    super.key,
    required this.pasien,
    required this.usernameNakes,
  });

  @override
  State<DetailPasienView> createState() => _DetailPasienViewState();
}

class _DetailPasienViewState extends State<DetailPasienView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final DetailPasienController _controller;

  // 🟢 VARIABEL BARU: Status Gembok Riwayat Luar
  bool _isRiwayatLuarTerbuka = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _controller = DetailPasienController();

    // 🚀 OTOMATIS HAJAR TARIK DATA PAS AWAL BUKA LAYAR COKK!
    String idPasien = widget.pasien['id_pasien']?.toString() ?? '1';
    _controller.muatRiwayatRMLive(
      idPasien,
      widget.usernameNakes,
      () => setState(() {}),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 🟢 FUNGSI BARU: Tampilkan Dialog Minta PIN
  void _tampilkanDialogInputPin(BuildContext context) {
    final TextEditingController txtPin = TextEditingController();

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Masukkan Kode Akses',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tanyakan 6 digit PIN akses kepada pasien untuk melihat riwayat luarnya.',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: txtPin,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "......",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  if (txtPin.text.length != 6) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(content: Text('PIN harus 6 digit angka!')),
                    );
                    return;
                  }

                  String pinInput = txtPin.text;
                  String idPasien =
                      widget.pasien['id_pasien']?.toString() ?? '0';
                  Navigator.pop(dialogContext); // Tutup pop-up

                  // 🟢 Eksekusi Cek PIN ke Database
                  try {
                    // Pastikan URL validasi_pin.php sesuai dengan konfigurasi kamu
                    var url = Uri.parse(ApiConstants.validasiPin);
                    var response = await http.post(
                      url,
                      body: {'id_pasien': idPasien, 'pin_akses': pinInput},
                    );

                    if (response.statusCode == 200) {
                      var data = jsonDecode(response.body);
                      if (data['status'] == 'success') {
                        // JIKA PIN BENAR
                        setState(() {
                          _isRiwayatLuarTerbuka = true; // Buka Gemboknya!
                        });
                        if (mounted)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Akses Diberikan!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                      } else {
                        // JIKA PIN SALAH
                        if (mounted)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('PIN Akses Salah!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                      }
                    }
                  } catch (e) {
                    if (mounted)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error jaringan: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                  }
                },
                child: const Text(
                  'Buka Akses',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String nama = widget.pasien['nama_lengkap'] ?? 'Tanpa Name';
    final String nik = widget.pasien['nik'] ?? '-';
    final String jkel = widget.pasien['jenis_kelamin'] ?? '-';
    final String tglLahir = widget.pasien['tgl_lahir'] ?? '-';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Data Pasien Full',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.medisPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nama,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textUtama,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$tglLahir - $jkel',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSekunder,
                            ),
                          ),
                          Text(
                            'NIK: $nik',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSekunder,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Pasien Terdaftar',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textUtama,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(
                          Icons.add_circle_outline_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        label: const Text(
                          'Tambah RM Baru',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          // 🟢 Mastiin setelah dari halaman RM, data riwayat di-refresh
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => InputRekamMedisView(
                                    pasien: widget.pasien,
                                    usernameNakes: widget.usernameNakes,
                                  ),
                            ),
                          );
                          String idPasien =
                              widget.pasien['id_pasien']?.toString() ?? '1';
                          _controller.muatRiwayatRMLive(
                            idPasien,
                            widget.usernameNakes,
                            () => setState(() {}),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(
                          Icons.edit_note_rounded,
                          color: AppColors.textUtama,
                          size: 16,
                        ),
                        label: const Text(
                          'Edit Profil',
                          style: TextStyle(
                            color: AppColors.textUtama,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey.shade50,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.textUtama,
              unselectedLabelColor: Colors.grey.shade400,
              indicatorColor: AppColors.textUtama,
              indicatorWeight: 3,
              tabs: [
                const Tab(
                  child: Text(
                    'Klinik Ini',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Riwayat Luar ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // 🟢 Ikon gembok berubah kalau udah kebuka
                      Icon(
                        _isRiwayatLuarTerbuka
                            ? Icons.lock_open_rounded
                            : Icons.lock_outline_rounded,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // TAB 1: LIST RIWAYAT LIVE
                _controller.isLoading
                    ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.medisPrimary,
                      ),
                    )
                    : _controller.listRiwayat.isEmpty
                    ? const Center(
                      child: Text(
                        'Belum ada riwayat pemeriksaan wakk.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _controller.listRiwayat.length,
                      itemBuilder: (context, index) {
                        final rm = _controller.listRiwayat[index];
                        return _buildCardRiwayat(
                          rm['tanggal'] ?? '-',
                          rm['jam'] ?? '-',
                          rm['diagnosa'] ?? '-',
                          rm['keluhan'] ?? '-',
                          rm,
                        );
                      },
                    ),

                // TAB 2: LOCK RIWAYAT LUAR
                _isRiwayatLuarTerbuka
                    ? RiwayatLuarView(
                      pasien: widget.pasien,
                      usernameNakes: widget.usernameNakes,
                    ) // 🟢 PANGGIL FILE BARU DI SINI
                    : ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.lock_rounded,
                                  color: Colors.grey,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Akses Riwayat Luar Terkunci',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textUtama,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Data riwayat pengobatan mandiri bersifat pribadi. Anda perlu meminta izin akses ke pasien untuk melihatnya.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSekunder,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade600,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.key_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                label: const Text(
                                  'Minta Izin Akses',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed:
                                    () => _tampilkanDialogInputPin(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardRiwayat(
    String tgl,
    String jam,
    String diagnosa,
    String keluhan,
    Map<String, dynamic> dataRMFull,
  ) {
    String namaDokter = dataRMFull['nama_dokter'] ?? 'Dokter Tidak Diketahui';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      DetailRmView(riwayat: dataRMFull, pasien: widget.pasien),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tgl,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textUtama,
                    ),
                  ),
                  Text(
                    jam,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                diagnosa,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                keluhan,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSekunder,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Divider(height: 1, color: Colors.black12),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.assignment_turned_in_rounded,
                    size: 12,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Oleh: $namaDokter',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSekunder,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
