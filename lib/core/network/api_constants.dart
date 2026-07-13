class ApiConstants {
  // Ganti IP ini dengan IP lokal komputer kamu (cek pakai ipconfig di cmd)
  static const String baseUrl = "http://localhost/sirmoapp_api/"; 

  static const String login = "${baseUrl}auth/login.php";
  static const String registerPasien = "${baseUrl}auth/register_pasien.php";
  static const String registerNakes = "${baseUrl}auth/register_nakes.php";
  static const String registerKlinik = "${baseUrl}auth/register_klinik.php";
  static const String getKlinik = "${baseUrl}auth/get_klinik.php";

  static const String getDashboardPasien = '${baseUrl}dashboard/get_dashboard_pasien.php';
  static const String getProfilPasien = '${baseUrl}dashboard/get_profil_pasien.php';
  
  static const String getRiwayatPasien = '${baseUrl}pasien/get_riwayat_pasien.php';
  static const String ambilRiwayatRM = '${baseUrl}pasien/ambil_riwayat_rm.php';
  static const String getDetailRm = '${baseUrl}pasien/get_detail_rm_pasien.php';
  static const String simpanMandiri = '${baseUrl}pasien/simpan_mandiri.php';

  static const String updateProfil = '${baseUrl}dashboard/update_profil_pasien.php';
  static const String hapusRiwayat = '${baseUrl}pasien/hapus_riwayat.php';

  // --- URL API SUPER ADMIN ---
  static String getDashboardSuperAdmin = '${baseUrl}super_admin/get_dashboard.php';
  static const String getDaftarKlinik = '${baseUrl}super_admin/get_klinik.php';
  static const String prosesValidasiSuperAdmin = '${baseUrl}super_admin/proses_validasi.php';
  static const String getKlinikSuperAdmin = '${baseUrl}super_admin/get_klinik.php';
  static const String getValidasiSuperAdmin = '${baseUrl}super_admin/get_validasi.php';
  static const String aksiKlinikSuperAdmin = '${baseUrl}super_admin/aksi_klinik.php';
  static const String getLatestLogSuperAdmin = '${baseUrl}super_admin/get_latest_log.php';

  static const String getKlinikList = '${baseUrl}auth/get_klinik_list.php';
  static const String setujuiNakes = "${baseUrl}super_admin/setujui_nakes.php";

//nakes
  static const String getDashboardNakes = "${baseUrl}nakes/get_dashboard_nakes.php";
  static const String getProfilNakes = "${baseUrl}nakes/get_profil_nakes.php";
  static const String updateProfilNakes = "${baseUrl}nakes/update_profil_nakes.php";

  static const String getPasien = "${baseUrl}nakes/get_pasien.php";
  static const String simpanPasien = "${baseUrl}nakes/simpan_pasien.php";

  static const String getRiwayatRm = "${baseUrl}nakes/get_riwayat_rm.php";

  static const String getObat = "${baseUrl}nakes/get_obat.php";
  static const String tambahObat = "${baseUrl}nakes/tambah_obat.php";
  static const String simpanRm = "${baseUrl}nakes/simpan_rm.php";

  static const String tarikPasienGlobal = "${baseUrl}nakes/tarik_pasien_global.php";

  static const String getInfoKlinik = "${baseUrl}nakes/get_info_klinik.php";

  static const String updatePin = "$baseUrl/dashboard/update_pin.php";
  static const String validasiPin = "$baseUrl/nakes/validasi_pin.php";

  static const String getRiwayatLuar = "$baseUrl/nakes/get_riwayat_luar.php";
}

