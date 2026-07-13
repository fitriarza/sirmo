import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared_widgets/custom_button.dart';
import '../../../shared_widgets/custom_textfield.dart';
import '../controllers/register_klinik_controller.dart';
import 'package:flutter/foundation.dart';

class RegisterKlinikView extends StatefulWidget {
  const RegisterKlinikView({super.key});

  @override
  State<RegisterKlinikView> createState() => _RegisterKlinikViewState();
}

class _RegisterKlinikViewState extends State<RegisterKlinikView> {
  late final RegisterKlinikController _con;

  @override
  void initState() {
    super.initState();
    _con = RegisterKlinikController();
  }

  void _refreshUI() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _con.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textUtama),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Daftarkan Klinik', style: TextStyle(fontSize: 28, fontWeight: AppSizes.fontBoldWeight, color: AppColors.textUtama)),
              const SizedBox(height: 8),
              const Text('Daftarkan fasilitas kesehatan Anda ke dalam jaringan SIRMO', style: TextStyle(fontSize: AppSizes.fontKecil, color: AppColors.textSekunder, fontWeight: AppSizes.fontMediumWeight)),
              const SizedBox(height: 32),

              // --- INFORMASI KLINIK ---
              const Divider(),
              const Text('1. INFORMASI KLINIK', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.medisPrimary)),
              const SizedBox(height: 16),
              
              _buildLabel('NAMA KLINIK'),
              CustomTextField(controller: _con.namaKlinikController, hintText: 'Contoh: Klinik Harapan Sehat', prefixIcon: Icons.local_hospital_outlined, keyboardType: TextInputType.text),
              const SizedBox(height: 16),
              
              _buildLabel('ALAMAT KLINIK'),
              CustomTextField(controller: _con.alamatController, hintText: 'Alamat lengkap klinik', prefixIcon: Icons.location_on_outlined, keyboardType: TextInputType.streetAddress),
              const SizedBox(height: 16),
              
              _buildLabel('NO. TELEPON KLINIK'),
              CustomTextField(controller: _con.noTelpController, hintText: 'Contoh: 08123456789', prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone),
              const SizedBox(height: 16),

              _buildLabel('UPLOAD SURAT IZIN KLINIK (PDF/JPG)'),
              _buildFilePicker(
                fileName: _con.selectedFileIzin?.name,
                onTap: () => _con.pickFileIzin(_refreshUI),
                hint: 'Tap untuk upload Izin Klinik'
              ),
              
              const SizedBox(height: 32),

              // --- INFORMASI OWNER / NAKES ---
              const Divider(),
              const Text('2. DATA PENANGGUNG JAWAB (NAKES)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.medisPrimary)),
              const SizedBox(height: 16),

              _buildLabel('NAMA LENGKAP OWNER/DOKTER'),
              CustomTextField(controller: _con.namaOwnerController, hintText: 'Masukkan nama beserta gelar', prefixIcon: Icons.badge_outlined, keyboardType: TextInputType.name),
              const SizedBox(height: 16),

              _buildLabel('PROFESI'),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _con.selectedProfesi,
                decoration: InputDecoration(
                  hintText: 'Pilih Profesi',
                  prefixIcon: const Icon(Icons.medical_services_outlined, color: Color(0xFF4F46E5), size: 20),
                  filled: true, fillColor: const Color(0xFFF9FAFB),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5)),
                ),
                items: _con.daftarProfesi.map((profesi) => DropdownMenuItem(value: profesi, child: Text(profesi))).toList(),
                onChanged: (val) => _con.changeProfesi(val, _refreshUI),
              ),
              const SizedBox(height: 16),

              _buildLabel('NIP / NOMOR STR'),
              CustomTextField(controller: _con.nipStrController, hintText: 'Masukkan nomor STR Nakes', prefixIcon: Icons.pin_outlined, keyboardType: TextInputType.text),
              const SizedBox(height: 16),

              _buildLabel('UPLOAD DOKUMEN STR (PDF/JPG)'),
              _buildFilePicker(
                fileName: _con.selectedFileStr?.name,
                onTap: () => _con.pickFileStr(_refreshUI),
                hint: 'Tap untuk upload dokumen STR'
              ),
              const SizedBox(height: 32),

              // --- INFORMASI AKUN ---
              const Divider(),
              const Text('3. AKUN LOGIN', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.medisPrimary)),
              const SizedBox(height: 16),

              _buildLabel('USERNAME'),
              CustomTextField(controller: _con.usernameController, hintText: 'Buat username tanpa spasi', prefixIcon: Icons.person_outline, keyboardType: TextInputType.text),
              const SizedBox(height: 16),

              _buildLabel('PASSWORD'),
              TextFormField(
                controller: _con.passwordController,
                obscureText: _con.obscurePassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.medisPrimary, size: 20),
                  suffixIcon: IconButton(icon: Icon(_con.obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.grey), onPressed: () => _con.togglePasswordVisibility(_refreshUI)),
                  filled: true, fillColor: AppColors.permukaan,
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.medisPrimary, width: 1.5)),
                ),
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: 'DAFTARKAN KLINIK',
                isLoading: _con.isLoading,
                onPressed: _con.isLoading ? null : () => _con.prosesRegisterKlinik(context, _refreshUI),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(padding: const EdgeInsets.only(left: 4, bottom: 6), child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: AppSizes.fontBoldWeight, color: AppColors.textSekunder, letterSpacing: 0.5)));
  }

  Widget _buildFilePicker({required String? fileName, required VoidCallback onTap, required String hint}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.permukaan, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.medisPrimary)),
        child: Row(
          children: [
            const Icon(Icons.file_upload_outlined, color: AppColors.medisPrimary),
            const SizedBox(width: 12),
            Expanded(child: Text(fileName ?? hint, style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis))),
          ],
        ),
      ),
    );
  }
}