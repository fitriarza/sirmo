import 'package:flutter/material.dart';
import '../controllers/detail_mandiri_controller.dart';

class DetailMandiriView extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailMandiriView({super.key, required this.data});

  @override
  State<DetailMandiriView> createState() => _DetailMandiriViewState();
}

class _DetailMandiriViewState extends State<DetailMandiriView> {
  final DetailMandiriController _con = DetailMandiriController();

  @override
  void initState() {
    super.initState();
    // Memasukkan data ke controller saat halaman diinisialisasi
    _con.initData(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // bg-gray-50
     appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4B5563)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Catatan Mandiri',
          style: TextStyle(color: Color(0xFF111827), fontSize: 16, fontWeight: FontWeight.bold),
        ),
        // 🟢 TOMBOL HAPUS DITAMBAHKAN DI SINI
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () async {
              // 1. Tampilkan konfirmasi
              bool confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Hapus Catatan"),
                  content: const Text("Yakin ingin menghapus data ini?"),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
                  ],
                ),
              ) ?? false;

              // 2. Jalankan aksi hapus
              if (confirm) {
                // Pastikan 'id_riwayat' ada di map widget.data
                await _con.hapusCatatan(widget.data['id_rm'].toString()); 
                Navigator.pop(context, true); // Balik ke halaman riwayat dan kirim sinyal sukses
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE5E7EB), height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: INFO UMUM ---
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tanggal Input', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6B7280))),
                      Text(_con.tanggal, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    ],
                  ),
                  const Divider(height: 24, color: Color(0xFFF3F4F6)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sumber Data', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6B7280))),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 14, color: Color(0xFF9CA3AF)),
                          const SizedBox(width: 8),
                          Text(_con.sumberData, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- SECTION 2: KELUHAN ---
            const Text('KELUHAN / DIAGNOSA SEMENTARA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6B7280), letterSpacing: 1)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                _con.keluhan,
                style: const TextStyle(fontSize: 14, color: Color(0xFF111827), height: 1.5),
              ),
            ),

            // --- SECTION 3: OBAT YANG DIKONSUMSI ---
            const Text('OBAT YANG DIKONSUMSI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6B7280), letterSpacing: 1)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.medication_outlined, color: Colors.orange.shade700, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _con.namaObat,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                    ),
                  ),
                ],
              ),
            ),
            
            // --- INFO PRIVASI ---
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700, size: 16),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Data ini bersifat pribadi dan hanya digunakan untuk pantauan mandiri.',
                      style: TextStyle(fontSize: 10, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}