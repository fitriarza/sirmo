import 'package:flutter/material.dart';
import 'package:sirmo_app/modules/auth/view/register_view.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared_widgets/custom_button.dart';
import '../../../shared_widgets/custom_textfield.dart';
import '../controllers/auth_controller.dart';
import 'register_klinik_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final AuthController _con;

  @override
  void initState() {
    super.initState();
    // 🔒 Otak controller dikunci di sini, anti-klining, anti-freeze!
    _con = AuthController();
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- LOGO MEWAH TEAL-CYAN GRADIENT ---
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      AppColors.gradientStart,
                      AppColors.gradientEnd
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.medisPrimary.withValues(alpha: 0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 8))
                    ],
                  ),
                  child: const Icon(Icons.favorite_rounded,
                      color: Colors.white, size: 36),
                ),
                const SizedBox(height: AppSizes.paddingMedium),
                const Text('SIRMO',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: AppSizes.fontBoldWeight,
                        color: AppColors.textUtama,
                        letterSpacing: 1)),
                const Text('Sistem Informasi Rekam Medis & Obat',
                    style: TextStyle(
                        fontSize: AppSizes.fontKecil,
                        color: AppColors.textSekunder,
                        fontWeight: AppSizes.fontMediumWeight)),
                const SizedBox(height: 35),

                // --- FORM INPUT ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. INPUT USERNAME
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 6),
                      child: Text('NOMOR HP / USERNAME',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: AppSizes.fontBoldWeight,
                              color: AppColors.textSekunder,
                              letterSpacing: 0.5)),
                    ),
                    CustomTextField(
                      controller: _con.usernameController,
                      hintText: 'Masukkan Nomor HP (Pasien) atau Username',
                      prefixIcon: Icons.person_outline_rounded,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: AppSizes.paddingMedium),

                    // 2. INPUT PASSWORD
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 6),
                      child: Text('PASSWORD',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: AppSizes.fontBoldWeight,
                              color: AppColors.textSekunder,
                              letterSpacing: 0.5)),
                    ),
                    TextFormField(
                      controller: _con.passwordController,
                      obscureText: _con.obscurePassword,
                      style: const TextStyle(
                          fontSize: AppSizes.fontReguler,
                          color: AppColors.textUtama),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: AppSizes.fontReguler),
                        prefixIcon: const Icon(Icons.lock_outline_rounded,
                            color: AppColors.medisPrimary, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _con.obscurePassword
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              color: const Color(0xFF94A3B8),
                              size: 20),
                          onPressed: () =>
                              _con.togglePasswordVisibility(_refreshUI),
                        ),
                        filled: true,
                        fillColor: AppColors.permukaan,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusKecil),
                            borderSide:
                                const BorderSide(color: AppColors.border)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusKecil),
                            borderSide: const BorderSide(
                                color: AppColors.medisPrimary, width: 1.5)),
                      ),
                    ),

                    // 🔄 MENU LUPA PASSWORD (SEWARNA & KLOP COKK)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'Fitur Lupa Password silakan hubungi Admin IT Politeknik Negeri Bengkalis ya cokk!')));
                        },
                        child: const Text(
                          'Lupa Password?',
                          style: TextStyle(
                              color: AppColors.medisPrimary,
                              fontSize: 12,
                              fontWeight: AppSizes.fontMediumWeight),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 🧱 TOMBOL LOGIN GLOBAL (MANGGIL CUSTOM BUTTON COKK!)
                    CustomButton(
                      text: 'MASUK',
                      isLoading: _con.isLoading,
                      onPressed: _con.isLoading
                          ? null
                          : () => _con.prosesLogin(context, _refreshUI),
                    ),
                    const SizedBox(height: 28),

                    // 🔄 MENU PENGGUNA BARU / DAFTAR AKUN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Belum memiliki akun? ',
                          style: TextStyle(
                              color: AppColors.textSekunder,
                              fontSize: AppSizes.fontReguler),
                        ),
                        GestureDetector(
                          onTap: () {
                            // 🟢 SEKARANG UDAH BISA PINDAH KE HALAMAN REGISTER!
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterView()),
                            );
                          },
                          child: const Text(
                            'Daftar Di Sini',
                            style: TextStyle(
                              color: AppColors.medisPrimary,
                              fontSize: AppSizes.fontReguler,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- DIVIDER ATAU ---
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Atau',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- TOMBOL REGISTER KLINIK ---
                    Center(
                      child: InkWell(
                        onTap: () {
                          // 🟢 PINTU GERBANG SUDAH DIBUKA WAK!
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const RegisterKlinikView())
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Punya fasilitas kesehatan? Daftarkan Klinik Anda',
                            style: TextStyle(
                              color: AppColors.medisPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}