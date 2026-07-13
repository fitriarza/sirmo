import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sirmo_app/modules/auth/view/login_view.dart';
import '../controllers/profil_pasien_controller.dart';
import 'edit_profil_view.dart';

class ProfilPasienView extends StatefulWidget {
  final String username;
  const ProfilPasienView({super.key, required this.username});

  @override
  State<ProfilPasienView> createState() => _ProfilPasienViewState();
}

class _ProfilPasienViewState extends State<ProfilPasienView> {
  final ProfilPasienController _con = ProfilPasienController();

  @override
  void initState() {
    super.initState();
    _con.fetchProfil(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text(
          'Profil Pasien',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF111827),
        centerTitle: true,
      ),
      // 🟢 TOMBOL EDIT (TIDAK DIGANGGU)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF111827),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => EditProfilView(
                    data: _con.dataProfil,
                    username: widget.username,
                  ),
            ),
          ).then(
            (value) => _con.fetchProfil(widget.username),
          ); // Auto refresh setelah edit
        },
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _con.isLoading,
        builder: (context, loading, child) {
          if (loading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF111827)),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF111827),
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  _con.dataProfil['nama_lengkap'] ?? 'Nama Tidak Ditemukan',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '@${widget.username}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 30),

                // Data yang disinkronkan dengan database
                _buildInfoCard(
                  Icons.badge_rounded,
                  'NIK',
                  _con.dataProfil['nik'] ?? '-',
                ),
                _buildInfoCard(
                  Icons.phone_rounded,
                  'Nomor HP',
                  _con.dataProfil['no_hp'] ?? '-',
                ),
                _buildInfoCard(
                  Icons.location_on_rounded,
                  'Alamat',
                  _con.dataProfil['alamat'] ?? '-',
                ),

                // Pengecekan agar tanggal lahir tidak 0000-00-00
                _buildInfoCard(
                  Icons.calendar_today_rounded,
                  'Tgl Lahir',
                  (_con.dataProfil['tgl_lahir'] == '0000-00-00' ||
                          _con.dataProfil['tgl_lahir'] == null)
                      ? 'Belum diatur'
                      : _con.dataProfil['tgl_lahir'],
                ),

                // 🟢 TOMBOL LOGOUT DIPINDAHKAN KE SINI AGAR BISA DIKLIK NORMAL
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Colors.red),
                  title: const Text(
                    'Keluar dari Akun',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    // Eksekusi Keluar
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear(); // Hapus semua data sesi login

                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ), // Arahkan balik ke halaman Login
                        (route) => false, // Hapus semua riwayat halaman sebelumnya
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🟢 FUNGSI CARD INFO SUDAH BERSIH DARI TOMBOL LOGOUT
  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF111827)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}