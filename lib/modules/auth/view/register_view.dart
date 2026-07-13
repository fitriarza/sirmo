import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared_widgets/custom_button.dart';
import '../../../shared_widgets/custom_textfield.dart';
import '../controllers/register_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final RegisterController _con;

  @override
  void initState() {
    super.initState();
    _con = RegisterController();

    // 🟢 Pastikan data klinik dari database ter-load supaya dropdown bisa dibuka
    _con.fetchKlinik(_refreshUI);
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
          icon:
              const Icon(Icons.arrow_back_rounded, color: AppColors.textUtama),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Buat Akun Baru',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: AppSizes.fontBoldWeight,
                  color: AppColors.textUtama,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Daftar untuk mengakses layanan SIRMO',
                style: TextStyle(
                  fontSize: AppSizes.fontKecil,
                  color: AppColors.textSekunder,
                  fontWeight: AppSizes.fontMediumWeight,
                ),
              ),
              const SizedBox(height: 32),

              // --- TOGGLE ROLE (Pasien vs Nakes) ---
              Container(
                decoration: BoxDecoration(
                  color: AppColors.permukaan,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSedang),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _con.changeRole('Pasien', _refreshUI),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _con.selectedRole == 'Pasien'
                                ? AppColors.medisPrimary
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusSedang),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Pasien',
                            style: TextStyle(
                              color: _con.selectedRole == 'Pasien'
                                  ? Colors.white
                                  : AppColors.textSekunder,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            _con.changeRole('Tenaga Medis', _refreshUI),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _con.selectedRole == 'Tenaga Medis'
                                ? AppColors.medisPrimary
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusSedang),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Tenaga Medis',
                            style: TextStyle(
                              color: _con.selectedRole == 'Tenaga Medis'
                                  ? Colors.white
                                  : AppColors.textSekunder,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- FORM INPUT UMUM ---
              _buildLabel('NAMA LENGKAP'),
              CustomTextField(
                controller: _con.namaController,
                hintText: 'Masukkan nama lengkap',
                prefixIcon: Icons.badge_rounded,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),

              _buildLabel('USERNAME / NIK / NOMOR HP'),
              CustomTextField(
                controller: _con.usernameController,
                hintText: 'Masukkan username atau NIK atau Nomor HP',
                prefixIcon: Icons.person_outline_rounded,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),

              _buildLabel('PASSWORD'),
              TextFormField(
                controller: _con.passwordController,
                obscureText: _con.obscurePassword,
                style: const TextStyle(
                    fontSize: AppSizes.fontReguler, color: AppColors.textUtama),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: const TextStyle(
                      color: Color(0xFF94A3B8), fontSize: AppSizes.fontReguler),
                  prefixIcon: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.medisPrimary, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _con.obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: const Color(0xFF94A3B8),
                      size: 20,
                    ),
                    onPressed: () => _con.togglePasswordVisibility(_refreshUI),
                  ),
                  filled: true,
                  fillColor: AppColors.permukaan,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusKecil),
                      borderSide: const BorderSide(color: AppColors.border)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusKecil),
                      borderSide: const BorderSide(
                          color: AppColors.medisPrimary, width: 1.5)),
                ),
              ),
              const SizedBox(height: 16),

              // --- FORM EKSTRA KHUSUS NAKES ---
              if (_con.selectedRole == 'Tenaga Medis') ...[
                const Divider(height: 32),

                _buildLabel('PILIH KLINIK'),
                _con.isLoadingKlinik
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _con.selectedKlinik,
                          decoration: InputDecoration(
                            hintText: 'Pilih Klinik Tempat Praktik',
                            hintStyle: const TextStyle(
                                color: Color(0xFF94A3B8), fontSize: 14),
                            prefixIcon: const Icon(
                              Icons.local_hospital_outlined,
                              color: Color(0xFF4F46E5),
                              size: 20,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFF4F46E5), width: 1.5),
                            ),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF9CA3AF)),
                          items: _con.listKlinik.map((klinik) {
                            return DropdownMenuItem<String>(
                              value: klinik['id_klinik'].toString(),
                              child: Text(
                                klinik['nama_klinik'],
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _con.selectedKlinik = newValue;
                            });
                          },
                        ),
                      ),
                const SizedBox(height: 16),

                _buildLabel('PROFESI'),

                // FIX: Dropdown harus ambil lebar yang tersedia (hindari RenderFlex overflow)
                SizedBox(
                  width: double.infinity,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _con.selectedProfesi,
                    decoration: InputDecoration(
                      hintText: 'Pilih Profesi',
                      hintStyle: const TextStyle(
                          color: Color(0xFF94A3B8), fontSize: 14),
                      prefixIcon: const Icon(
                        Icons.medical_services_outlined,
                        color: Color(0xFF4F46E5),
                        size: 20,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF4F46E5), width: 1.5),
                      ),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF9CA3AF)),
                    items: _con.daftarProfesi.map((String profesi) {
                      return DropdownMenuItem<String>(
                        value: profesi,
                        child: Text(
                          profesi,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) =>
                        _con.changeProfesi(newValue, _refreshUI),
                  ),
                ),

                const SizedBox(height: 16),
                _buildLabel('NIP / NOMOR STR'),
                CustomTextField(
                  controller: _con.nipStrController,
                  hintText: 'Masukkan nomor STR',
                  prefixIcon: Icons.pin_outlined,
                  keyboardType: TextInputType.text,
                ),

                const SizedBox(height: 16),
                _buildLabel('DOKUMEN (STR/SIP)'),

                InkWell(
                  onTap: () async {
                    await _con.pickDocumentFile(context, _refreshUI);
                  },
                  borderRadius: BorderRadius.circular(AppSizes.radiusKecil),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.permukaan,
                      borderRadius: BorderRadius.circular(AppSizes.radiusKecil),
                      border: Border.all(color: AppColors.medisPrimary),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.file_upload_outlined,
                            color: AppColors.medisPrimary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _con.selectedDocumentName == null
                                ? 'Tap untuk upload dokumen (STR/SIP)'
                                : 'Dokumen dipilih: ${_con.selectedDocumentName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],

              const SizedBox(height: 24),
              // --- TOMBOL DAFTAR ---
              CustomButton(
                text: 'DAFTAR SEKARANG',
                isLoading: _con.isLoading,
                onPressed: _con.isLoading
                    ? null
                    : () => _con.prosesRegister(context, _refreshUI),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: AppSizes.fontBoldWeight,
          color: AppColors.textSekunder,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
