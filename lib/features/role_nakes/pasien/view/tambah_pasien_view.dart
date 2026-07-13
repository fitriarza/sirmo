import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../controllers/tambah_pasien_controller.dart';

class TambahPasienView extends StatefulWidget {
  final String usernameNakes;
  const TambahPasienView({super.key, required this.usernameNakes});

  @override
  State<TambahPasienView> createState() => _TambahPasienViewState();
}

class _TambahPasienViewState extends State<TambahPasienView> {
  // 🟢 LANGKAH AMAN: Kita inisialisasi murni tanpa embel-embel callback dulu wakk!
  final TambahPasienController _con = TambahPasienController();

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
        title: const Text(
          'Tambah Pasien Baru',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textUtama,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textUtama),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // 1. INPUT NIK
                _buildLabel('NIK (Nomor Induk Kependudukan)'),
                TextField(
                  controller: _con.nikController,
                  keyboardType: TextInputType.number,
                  maxLength: 16, // 🟢 KUNCI MATI MAKSIMAL 16 DIGIT COKK!
                  style: const TextStyle(fontSize: 14),
                  decoration: _buildInputDecoration('16 digit angka').copyWith(
                    counterText: "", // Menyembunyikan angka counter bawaan
                  ),
                ),
                const SizedBox(height: 16),

                // 2. INPUT NAMA LENGKAP
                _buildLabel('Nama Lengkap'),
                TextField(
                  controller: _con.namaController,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(fontSize: 14),
                  decoration: _buildInputDecoration('Sesuai KTP'),
                ),
                const SizedBox(height: 16),

                // 3. ROW TGL LAHIR & JENIS KELAMIN
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Tanggal Lahir'),
                          TextField(
                            controller: _con.tglLahirController,
                            readOnly: true,
                            style: const TextStyle(fontSize: 14),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2000),
                                firstDate: DateTime(1940),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _con.tglLahirController.text =
                                      "${pickedDate.toLocal()}".split(' ')[0];
                                });
                              }
                            },
                            decoration: _buildInputDecoration(
                              'YYYY-MM-DD',
                            ).copyWith(
                              suffixIcon: const Icon(
                                Icons.calendar_month_rounded,
                                size: 18,
                                color: AppColors.medisPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Jenis Kelamin'),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMedium,
                              ),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _con.jenisKelamin,
                                isExpanded: true,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textUtama,
                                ),
                                items:
                                    <String>['Laki-laki', 'Perempuan'].map((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _con.jenisKelamin = val;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 4. INPUT NOMOR HP
                _buildLabel('Nomor HP / WhatsApp'),
                TextField(
                  controller: _con.noHpController,
                  keyboardType: TextInputType.phone,
                  maxLength:
                      13, // 🟢 KUNCI MATI MAKSIMAL 13 DIGIT BIAR GA OVER COKK!
                  style: const TextStyle(fontSize: 14),
                  decoration: _buildInputDecoration('8xx-xxxx-xxxx').copyWith(
                    counterText: "", // Sembunyikan text counter wakk
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text(
                        '+62 ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textUtama,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 5. INPUT ALAMAT
                _buildLabel('Alamat Domisili'),
                TextField(
                  controller: _con.alamatController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 14),
                  decoration: _buildInputDecoration('Dusun, RT/RW, Desa...'),
                ),
                const SizedBox(height: 16),

                // 6. OPSIONAL BOX PASSWORD (AKUN PASIEN)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    border: Border.all(color: const Color(0xFFDBEAFE)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Buat Password Akun',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E40AF),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 42,
                        child: TextField(
                          controller: _con.passwordController,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                color: Color(0xFFBFDBFE),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                color: Color(0xFF1E40AF),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '*Pasien bisa login menggunakan Nomor HP & password ini.', // ✅
                        style: TextStyle(fontSize: 9, color: Color(0xFF2563EB)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🟢 BOTTOM BOX BUTTON (SIMPAN)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textUtama,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  elevation: 0,
                ),
                onPressed:
                    _con.isLoading
                        ? null
                        : () => _con.simpanPasien(
                          context,
                          widget.usernameNakes,
                          () => setState(() {}),
                        ),
                child:
                    _con.isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text(
                          'SIMPAN DATA PASIEN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String teks) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 6),
      child: Text(
        teks,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF475569),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.all(14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        borderSide: const BorderSide(color: AppColors.textUtama, width: 1.2),
      ),
    );
  }
}
