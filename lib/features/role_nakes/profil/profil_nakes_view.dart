import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sirmo_app/modules/auth/view/login_view.dart'; // Pastikan path ini sesuai dengan file login kamu
import '../../../../core/constants/app_colors.dart';
import 'profil_nakes_controller.dart';

class ProfilNakesView extends StatefulWidget {
  final String username;
  const ProfilNakesView({super.key, required this.username});

  @override
  State<ProfilNakesView> createState() => _ProfilNakesViewState();
}

class _ProfilNakesViewState extends State<ProfilNakesView> {
  final ProfilNakesController _con = ProfilNakesController();

  // 🟢 FUNGSI BARU: Menampilkan Form Pop-up Edit Profil
  void _tampilkanPopUpEdit(BuildContext context, Map<String, dynamic> profil) {
    // Controller untuk menangkap inputan teks dengan nilai awal dari database
    final TextEditingController txtNama = TextEditingController(text: profil['nama_lengkap']);
    final TextEditingController txtProfesi = TextEditingController(text: profil['profesi']);
    final TextEditingController txtNip = TextEditingController(text: profil['nip_str']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(modalContext).viewInsets.bottom, // Biar nggak ketutup keyboard
            left: 24,
            right: 24,
            top: 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Edit Profil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                    GestureDetector(
                      onTap: () => Navigator.pop(modalContext),
                      child: const Icon(Icons.close, color: Colors.grey),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                
                // Form Nama Lengkap
                TextField(
                  controller: txtNama,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.person_outline, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Form Profesi
                TextField(
                  controller: txtProfesi,
                  decoration: InputDecoration(
                    labelText: 'Profesi (Contoh: Dokter Umum)',
                    labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.medical_services_outlined, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Form NIP / STR
                TextField(
                  controller: txtNip,
                  decoration: InputDecoration(
                    labelText: 'Nomor NIP / STR',
                    labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.badge_outlined, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Tutup modal loading (opsional bisa ditambah loading indikator)
                      Navigator.pop(modalContext);

                      // Panggil fungsi Update di Controller
                      bool sukses = await _con.updateProfilData(
                        widget.username,
                        txtNama.text,
                        txtProfesi.text,
                        txtNip.text,
                      );

                      if (sukses) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui!'), backgroundColor: Colors.green));
                          // Refresh halaman agar data baru langsung muncul
                          setState(() {}); 
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal memperbarui profil!'), backgroundColor: Colors.red));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Simpan Perubahan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          )
          );
        },
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('Profil Saya', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _con.fetchProfilData(widget.username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.medisPrimary));
          }

          final profil = snapshot.data ?? {};

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // 1. HEADER PROFIL
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(color: Colors.blue.shade100, shape: BoxShape.circle),
                          child: const Icon(Icons.person_rounded, size: 60, color: Colors.blue),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.verified_rounded, color: Colors.blue, size: 20),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(profil['nama_lengkap'] ?? '-', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        (profil['profesi'] ?? 'Tenaga Medis').toUpperCase(),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 🟢 TOMBOL EDIT MUNCUL DI SINI
                    OutlinedButton.icon(
                      onPressed: () => _tampilkanPopUpEdit(context, profil),
                      icon: const Icon(Icons.edit_note_rounded, size: 18),
                      label: const Text('Edit Profil', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue.shade700,
                        side: BorderSide(color: Colors.blue.shade200),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 2. INFORMASI PEGAWAI
              const Text('INFORMASI PEGAWAI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildListTile(Icons.badge_rounded, 'Nomor NIP/STR', profil['nip_str'] ?? '-'),
                    const Divider(height: 1, indent: 50),
                    _buildListTile(Icons.date_range_rounded, 'Tanggal Bergabung', profil['tgl_gabung'] ?? '-'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. TOMBOL LOGOUT
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red.shade200),
                  ),
                ),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Keluar Aplikasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                onPressed: () => _tampilkanPopUpLogout(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  void _tampilkanPopUpLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi SIRMO?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context); // Tutup dialognya dulu
              
              // 🟢 EKSEKUSI PENGHAPUSAN SESI DAN NAVIGASI
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear(); 
              
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              }
            },
            child: const Text('Ya, Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}