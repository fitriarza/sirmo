import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../controllers/daftar_pasien_controller.dart';
import 'tambah_pasien_view.dart';
import 'detail_pasien_view.dart';
import 'input_rekam_medis_view.dart';

class DaftarPasienView extends StatefulWidget {
  final String usernameNakes; 
  
  const DaftarPasienView({super.key, required this.usernameNakes});

  @override
  State<DaftarPasienView> createState() => _DaftarPasienViewState();
}

class _DaftarPasienViewState extends State<DaftarPasienView> {
  late final DaftarPasienController _con;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _con = DaftarPasienController();
    _panggilDatabase();
  }

  Future<void> _panggilDatabase() async {
    if (!mounted) return;
    setState(() => _con.isLoading = true);
    
    // Lempar username ke controller biar bisa narik data klinik
    await _con.muatDataPasien(widget.usernameNakes); 
    
    if (mounted) {
      setState(() {});
    }
  }
  

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 🟢 FUNGSI BARU: DIALOG TARIK PASIEN GLOBAL
  void _tampilkanDialogTarikPasien() {
    final TextEditingController hpController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Tarik Pasien Global', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Masukkan Nomor HP (Username) pasien yang sudah terdaftar di sistem pusat.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: hpController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Contoh: 081234567890',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.phone_android_rounded, size: 20, color: AppColors.medisPrimary),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.medisPrimary),
              onPressed: () async {
                if (hpController.text.isNotEmpty) {
                  Navigator.pop(context); // Tutup dialog
                  
                  // Panggil fungsi controller untuk tarik data
                  bool sukses = await _con.tarikPasienGlobal(context, hpController.text, widget.usernameNakes, () => setState(() {}));
                  
                  if (sukses) {
                    _panggilDatabase(); // Refresh list otomatis jika sukses
                  }
                }
              },
              child: const Text('Tarik Data', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      appBar: AppBar(
        title: const Text('Data Pasien', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.medisPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          // 🟢 IKON 1: TAMBAH PASIEN BARU MANUAL
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 22),
            onPressed: () async {
              final hasilDataBaru = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TambahPasienView(usernameNakes: widget.usernameNakes),
                ),
              );

              if (hasilDataBaru == true) {
                _panggilDatabase();
              }
            },
          ),
          // 🟢 IKON 2: TARIK PASIEN GLOBAL
          IconButton(
            icon: const Icon(Icons.cloud_download_rounded, color: Colors.white, size: 22),
            onPressed: _tampilkanDialogTarikPasien,
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [
          // SEARCH BAR
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.medisPrimary,
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _con.filterPencarian(value);
                setState(() {});
              },
              style: const TextStyle(fontSize: AppSizes.fontReguler),
              decoration: InputDecoration(
                hintText: 'Cari Nama / NIK...',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.medisPrimary, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMedium), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMedium), borderSide: BorderSide.none),
              ),
            ),
          ),

          // LIST DATA PASIEN
          Expanded(
            child: _con.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.medisPrimary))
                : _con.pasienFilter.isEmpty
                    ? const Center(child: Text('Pasien tidak ditemukan.', style: TextStyle(color: AppColors.textSekunder, fontSize: 13)))
                    : RefreshIndicator(
                        color: AppColors.medisPrimary,
                        onRefresh: _panggilDatabase,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _con.pasienFilter.length,
                          itemBuilder: (context, index) {
                            final pasien = _con.pasienFilter[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppSizes.radiusBesar),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.only(left: 16, right: 12, top: 6, bottom: 6),
                                
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPasienView(
                                        pasien: pasien,
                                        usernameNakes: widget.usernameNakes, 
                                      ),
                                    ),
                                  );
                                },
                                
                                title: Text(
                                  pasien['nama_lengkap'] ?? 'Tanpa Nama',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textUtama),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text('NIK: ${pasien['nik'] ?? '-'}', style: const TextStyle(fontSize: 11, color: AppColors.textSekunder)),
                                ),
                                
                                trailing: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.medisPrimary.withValues(alpha: 0.1),
                                    foregroundColor: AppColors.medisPrimary,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  icon: const Icon(Icons.post_add_rounded, size: 16),
                                  label: const Text('Input RM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InputRekamMedisView(
                                          pasien: pasien,
                                          usernameNakes: widget.usernameNakes, 
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
  
}