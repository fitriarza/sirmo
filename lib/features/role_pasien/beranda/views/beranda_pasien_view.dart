import 'package:flutter/material.dart';
import '../controllers/beranda_pasien_controller.dart';

class BerandaPasienView extends StatefulWidget {
  final String username;

  const BerandaPasienView({super.key, required this.username});

  @override
  State<BerandaPasienView> createState() => _BerandaPasienViewState();
}

class _BerandaPasienViewState extends State<BerandaPasienView> {
  final BerandaPasienController _con = BerandaPasienController();
  final Color navyColor = const Color(0xFF2B4C7E);

  @override
  void initState() {
    super.initState();
    _con.fetchDashboard(widget.username);
  }

  // 🟢 POP-UP UNTUK UBAH PIN
  // 🟢 POP-UP UNTUK UBAH PIN (SUDAH DIPERBAIKI CONTEXT-NYA)
  void _tampilkanDialogEditPin(BuildContext context) {
    final TextEditingController txtPin = TextEditingController(text: _con.pinAkses);
    
    showDialog(
      context: context,
      // 🟢 Ubah nama parameter jadi dialogContext
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Ubah PIN Akses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('PIN ini digunakan untuk memberi izin nakes melihat riwayat pengobatan luar Anda.', style: TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 16),
            TextField(
              controller: txtPin,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
              decoration: InputDecoration(
                counterText: "",
                hintText: "123456",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            // 🟢 Tutup pakai dialogContext
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: navyColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () async {
              if (txtPin.text.length != 6) {
                // Tampilkan error di dialog
                ScaffoldMessenger.of(dialogContext).showSnackBar(const SnackBar(content: Text('PIN harus 6 digit angka!')));
                return;
              }
              
              // Simpan isi teks dulu sebelum dialognya ditutup
              String pinBaru = txtPin.text;
              
              // 🟢 Tutup dialog dengan dialogContext
              Navigator.pop(dialogContext); 
              
              // Eksekusi ke database
              bool sukses = await _con.updatePinAkses(widget.username, pinBaru);
              
              // 🟢 Tampilkan pesan sukses menggunakan context utama dari halaman Beranda (bukan dialogContext)
              if (sukses && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN Akses berhasil diperbarui!'), backgroundColor: Colors.green));
                setState(() { _con.pinAkses = pinBaru; }); 
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal memperbarui PIN.'), backgroundColor: Colors.red));
              }
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: ValueListenableBuilder<bool>(
        valueListenable: _con.isLoading,
        builder: (context, loading, child) {
          if (loading) {
            return Center(child: CircularProgressIndicator(color: navyColor));
          }

          return Column(
            children: [
              // --- HEADER BAGIAN ATAS (NAVY LEMBUT) ---
              Container(
                padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
                decoration: BoxDecoration(
                  color: navyColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(color: navyColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  children: [
                    // Info Nama & RM
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _con.namaLengkap,
                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(100)
                                ),
                                child: Text(
                                  'No. RM: ${_con.noRm}',
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
                          ),
                          child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 22),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 🟢 KARTU PIN AKSES BARU
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lock_person_rounded, color: Colors.white, size: 20),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('PIN Akses Riwayat Luar', style: TextStyle(color: Colors.white70, fontSize: 10)),
                                  Text(_con.pinAkses, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 4)),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => _tampilkanDialogEditPin(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                              child: const Icon(Icons.edit, color: Colors.white, size: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Kartu Frekuensi Sakit
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border(left: BorderSide(color: navyColor, width: 4)),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'FREKUENSI SAKIT ANDA (TAHUN INI)',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: navyColor, letterSpacing: 0.5),
                              ),
                              Icon(Icons.monitor_heart_outlined, color: navyColor, size: 16),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          if (_con.frekuensiSakit.isEmpty)
                            const Text("Belum ada data penyakit tahun ini.", style: TextStyle(fontSize: 12, color: Colors.black54, fontStyle: FontStyle.italic))
                          else
                            ..._con.frekuensiSakit.asMap().entries.map((entry) {
                              int index = entry.key + 1;
                              var data = entry.value;
                              double percentage = (index == 1) ? 0.75 : 0.50; 
                              
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('$index. ${data['diagnosa']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                                        Text('${data['jumlah']}x', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: navyColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: percentage,
                                        backgroundColor: const Color(0xFFE5E7EB),
                                        color: index == 1 ? navyColor : navyColor.withValues(alpha: 0.5),
                                        minHeight: 6,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // --- BAGIAN BAWAH (SCROLLABLE) ---
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Aktivitas Terbaru', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                          Icon(Icons.history_rounded, size: 18, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (_con.aktivitasTerbaru.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text("Belum ada aktivitas terbaru.", style: TextStyle(fontSize: 12, color: Colors.black54)),
                          )
                        )
                      else
                        ..._con.aktivitasTerbaru.map((data) {
                          bool isMandiri = data['jenis'] == 'Input Riwayat Mandiri';
                          Color accentColor = isMandiri ? Colors.orange.shade600 : Colors.blue.shade600;
                          
                          String teksKeterangan = isMandiri 
                              ? "Mengkonsumsi ${data['detail']} - ${data['tanggal']}" 
                              : "Pemeriksaan ${data['detail']} - ${data['tanggal']}";

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: accentColor.withValues(alpha: 0.2)),
                              boxShadow: [
                                BoxShadow(color: accentColor.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 4))
                              ]
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 10, height: 10,
                                  margin: const EdgeInsets.only(top: 4, right: 14),
                                  decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['jenis'] ?? 'Aktivitas', 
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accentColor)
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        teksKeterangan, 
                                        style: const TextStyle(fontSize: 11, color: Color(0xFF4B5563))
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}