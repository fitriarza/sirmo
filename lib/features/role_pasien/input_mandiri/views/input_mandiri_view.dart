import 'package:flutter/material.dart';
import '../controllers/input_mandiri_controller.dart';

class InputMandiriView extends StatefulWidget {
  final String username;
  const InputMandiriView({super.key, required this.username});

  @override
  State<InputMandiriView> createState() => _InputMandiriViewState();
}

class _InputMandiriViewState extends State<InputMandiriView> {
  final InputMandiriController _con = InputMandiriController();
  final List<String> gejalaTerpilih = [];

  // Daftar gejala lengkap
  final List<String> daftarGejala = [
    'Demam', 'Meriang', 'Menggigil', 'Lemas', 'Mudah Lelah', 'Badan Pegal', 'Nyeri Otot', 'Nyeri Sendi',
    'Sakit Kepala', 'Pusing', 'Vertigo', 'Mual', 'Muntah', 'Nyeri Perut', 'Perut Kembung', 'Diare', 
    'Batuk Kering', 'Batuk Berdahak', 'Sesak Napas', 'Sakit Tenggorokan', 'Pilek', 'Hidung Tersumbat',
    'Gatal', 'Ruam', 'Jantung Berdebar', 'Kesemutan', 'Sulit Tidur', 'Cemas', 'Anyang-anyangan'
  ];

  @override
  void dispose() {
    _con.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAFB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Catatan Mandiri', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.yellow.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.yellow.shade200)),
              child: const Row(children: [
                Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20),
                SizedBox(width: 10),
                Expanded(child: Text('Pilih gejala di bawah atau ketik manual.', style: TextStyle(fontSize: 11))),
              ]),
            ),
            const SizedBox(height: 24),

            const Text('Nama Obat / Tindakan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(controller: _con.namaObatController, decoration: _inputDeco('Contoh: Panadol 500mg')),
            const SizedBox(height: 20),
            
            const Text('Pilih Keluhan (Bisa Pilih Banyak)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: daftarGejala.map((gejala) {
                bool isSelected = gejalaTerpilih.contains(gejala);
                return FilterChip(
                  label: Text(gejala, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : Colors.black87)),
                  selected: isSelected,
                  selectedColor: Colors.black87,
                  backgroundColor: Colors.grey.shade100,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        gejalaTerpilih.add(gejala);
                      } else {
                        gejalaTerpilih.remove(gejala);
                      }
                      _con.keluhanController.text = gejalaTerpilih.join(', ');
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            
            const Text('Detail Tambahan (Jika Ada)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(controller: _con.keluhanController, maxLines: 3, decoration: _inputDeco('Opsional: Tambahkan info lain...')),
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _con.simpanCatatan(context, widget.username),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF111827), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('SIMPAN CATATAN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
    );
  }
}