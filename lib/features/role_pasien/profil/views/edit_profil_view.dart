import 'package:flutter/material.dart';
import '../controllers/profil_pasien_controller.dart';

class EditProfilView extends StatefulWidget {
  final Map<String, dynamic> data;
  final String username;
  const EditProfilView({super.key, required this.data, required this.username});

  @override
  State<EditProfilView> createState() => _EditProfilViewState();
}

class _EditProfilViewState extends State<EditProfilView> {
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _alamat = TextEditingController();
  final TextEditingController _nik = TextEditingController();
  final TextEditingController _hp = TextEditingController();
  final TextEditingController _tglLahir = TextEditingController(); // 🟢 CONTROLLER BARU
  final ProfilPasienController _con = ProfilPasienController();

  @override
  void initState() {
    super.initState();
    _nama.text = widget.data['nama_lengkap'] ?? '';
    _alamat.text = widget.data['alamat'] ?? '';
    _nik.text = widget.data['nik'] ?? '';
    _hp.text = widget.data['no_hp'] ?? '';
    
    // 🟢 Tarik data tanggal lahir dari DB
    String tgl = widget.data['tgl_lahir'] ?? '';
    _tglLahir.text = (tgl == '0000-00-00') ? '' : tgl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profil", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Informasi Pribadi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildTextField("Nama Lengkap", _nama, Icons.person_outline),
            _buildTextField("NIK", _nik, Icons.badge_outlined),
            _buildTextField("Nomor HP", _hp, Icons.phone_outlined),
            
            // 🟢 WIDGET KALENDER UNTUK TANGGAL LAHIR
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: _tglLahir,
                readOnly: true, // Biar nggak bisa diketik manual
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000), // Default mulai dari tahun 2000
                    firstDate: DateTime(1940),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _tglLahir.text = "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: "Tanggal Lahir",
                  prefixIcon: Icon(Icons.calendar_today_outlined, color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF111827))),
                ),
              ),
            ),

            _buildTextField("Alamat", _alamat, Icons.location_on_outlined, maxLines: 2),
            
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  // 🟢 KIRIM DATA TANGGAL LAHIR KE CONTROLLER
                  bool sukses = await _con.updateFullProfil(widget.username, _nama.text, _alamat.text, _nik.text, _hp.text, _tglLahir.text);
                  if (sukses && context.mounted) Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111827),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text("SIMPAN PERUBAHAN", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey.shade400),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF111827))),
        ),
      ),
    );
  }
}