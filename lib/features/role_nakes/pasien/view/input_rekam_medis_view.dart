import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/input_rekam_medis_controller.dart';

class InputRekamMedisView extends StatefulWidget {
  final Map<String, dynamic> pasien;
  final String usernameNakes;

  const InputRekamMedisView({
    super.key,
    required this.pasien,
    required this.usernameNakes,
  });

  @override
  State<InputRekamMedisView> createState() => _InputRekamMedisViewState();
}

class _InputRekamMedisViewState extends State<InputRekamMedisView> {
  late final InputRekamMedisController _controller;

  // 🟢 1. TAMBAHKAN DAFTAR GEJALA & LIST PENYIMPAN SEMENTARA
  final List<String> daftarGejala = [
    'Demam',
    'Meriang',
    'Menggigil',
    'Lemas',
    'Mudah Lelah',
    'Badan Pegal',
    'Nyeri Otot',
    'Nyeri Sendi',
    'Sakit Kepala',
    'Pusing',
    'Vertigo',
    'Mual',
    'Muntah',
    'Nyeri Perut',
    'Perut Kembung',
    'Diare',
    'Batuk Kering',
    'Batuk Berdahak',
    'Sesak Napas',
    'Sakit Tenggorokan',
    'Pilek',
    'Hidung Tersumbat',
    'Gatal',
    'Ruam',
    'Jantung Berdebar',
    'Kesemutan',
    'Sulit Tidur',
    'Cemas',
    'Anyang-anyangan',
  ];
  final List<String> gejalaTerpilih = [];

  @override
  void initState() {
    super.initState();
    _controller = InputRekamMedisController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.muatDaftarObat(() => setState(() {}));
    });
  }

  @override
  void dispose() {
    _controller.hancurkanController();
    super.dispose();
  }

  void _eksekusiSimpanRM() async {
    String idPasien = widget.pasien['id_pasien']?.toString() ?? '1';
    setState(() {});

    bool sukses = await _controller.kirimDataRekamMedisLive(
      idPasien,
      widget.usernameNakes,
    );

    if (mounted) {
      if (sukses) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🚀 Sukses! Data RM Masuk Database!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🚨 Gagal menyimpan rekam medis!'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _bukaPopUpTambahObat(int resepIndex) {
    final namaObatBaruController = TextEditingController();
    final takaranObatController = TextEditingController();
    String jenisTerpilih = 'Tablet';
    final List<String> listJenis = [
      'Tablet',
      'Kapsul',
      'Botol',
      'Puyer',
      'Tube',
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setPopUpState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text(
                'Tambah Obat Permanen',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nama Obat',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: namaObatBaruController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Contoh: Paracetamol',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Takaran / Kekuatan Dosis',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: takaranObatController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Contoh: 500 mg',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Satuan',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: jenisTerpilih,
                          isExpanded: true,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          items:
                              listJenis.map((String jenis) {
                                return DropdownMenuItem<String>(
                                  value: jenis,
                                  child: Text(jenis),
                                );
                              }).toList(),
                          onChanged:
                              (val) =>
                                  setPopUpState(() => jenisTerpilih = val!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    if (namaObatBaruController.text.isNotEmpty) {
                      Navigator.pop(context);
                      String namaLengkap =
                          "${namaObatBaruController.text} ${takaranObatController.text}";
                      await _controller.suntikObatBaruOnTheFly(
                        context: context,
                        namaObat: namaLengkap,
                        satuan: jenisTerpilih,
                        index: resepIndex,
                        updateUI: () => setState(() {}),
                      );
                    }
                  },
                  child: const Text(
                    'Simpan Database',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String namaPasien = widget.pasien['nama_lengkap'] ?? 'Tanpa Nama';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Input Rekam Medis',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _controller.isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.medisPrimary),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PASIEN',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                namaPasien,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Tanda Vital',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller.tekananDarahController,
                                style: const TextStyle(fontSize: 13),
                                decoration: const InputDecoration(
                                  hintText: 'Tensi (120/80)',
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _controller.suhuController,
                                style: const TextStyle(fontSize: 13),
                                decoration: const InputDecoration(
                                  hintText: 'Suhu (°C)',
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Pemeriksaan',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),

                        // 🟢 2. UI CHIPS PEMILIHAN KELUHAN
                        const Text(
                          'Pilih Keluhan (Bisa Pilih Banyak)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing:
                              8, // Mengurangi jarak vertikal antar chip biar lebih rapat
                          children:
                              daftarGejala.map((gejala) {
                                bool isSelected = gejalaTerpilih.contains(
                                  gejala,
                                );
                                return FilterChip(
                                  label: Text(
                                    gejala,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                    ),
                                  ),
                                  selected: isSelected,
                                  selectedColor:
                                      AppColors
                                          .medisPrimary, // Pakai warna tema utama aplikasi
                                  backgroundColor: Colors.grey.shade100,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        gejalaTerpilih.add(gejala);
                                      } else {
                                        gejalaTerpilih.remove(gejala);
                                      }
                                      // Gabungkan gejala ke text controller
                                      _controller
                                          .keluhanController
                                          .text = gejalaTerpilih.join(', ');
                                    });
                                  },
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 12),

                        // 🟢 3. TEXT FIELD UNTUK KETIK MANUAL / TAMBAHAN
                        TextField(
                          controller: _controller.keluhanController,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Atau ketik keluhan tambahan di sini...',
                            hintStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextField(
                          controller: _controller.diagnosaController,
                          style: const TextStyle(fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: 'Diagnosa Utama',
                          ),
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 12), // Jarak
                        TextField(
                          controller:
                              _controller
                                  .solusiCatatanController, // 🟢 Tambah ini
                          maxLines: 3, // Biar leluasa nulis catatannya
                          style: const TextStyle(fontSize: 13),
                          decoration: const InputDecoration(
                            labelText: 'Solusi / Catatan Dokter',
                            hintText:
                                'Masukkan saran atau catatan khusus untuk pasien...',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const Text(
                          'Resep Obat',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),

                        if (_controller.isObatLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.medisPrimary,
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _controller.listResepObat.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value:
                                                _controller
                                                    .listResepObat[index]['id_obat'],
                                            isExpanded: true,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87,
                                            ),
                                            items:
                                                _controller.masterObat.map((
                                                  Map<String, dynamic> obat,
                                                ) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value:
                                                        obat['id_obat']
                                                            .toString(),
                                                    child: Text(
                                                      obat['nama_obat']
                                                          .toString(),
                                                    ),
                                                  );
                                                }).toList(),
                                            onChanged: (newId) {
                                              setState(() {
                                                _controller
                                                        .listResepObat[index]['id_obat'] =
                                                    newId!;
                                                _controller
                                                        .listResepObat[index]['nama'] =
                                                    _controller.masterObat
                                                        .firstWhere(
                                                          (e) =>
                                                              e['id_obat']
                                                                  .toString() ==
                                                              newId,
                                                        )['nama_obat'];
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle,
                                        color: Colors.green,
                                      ),
                                      onPressed:
                                          () => _bukaPopUpTambahObat(index),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: TextField(
                                        style: const TextStyle(fontSize: 12),
                                        onChanged:
                                            (val) =>
                                                _controller
                                                        .listResepObat[index]['dosis'] =
                                                    val,
                                        decoration: const InputDecoration(
                                          hintText: 'Aturan Pakai (3x1 Tab)',
                                          hintStyle: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        TextButton(
                          onPressed:
                              () => _controller.tambahBarisObat(
                                () => setState(() {}),
                              ),
                          child: const Text(
                            '+ Tambah Baris Obat',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 10),

                        CheckboxListTile(
                          title: const Text(
                            'Terbitkan Surat Sakit?',
                            style: TextStyle(fontSize: 12),
                          ),
                          value: _controller.terbitSuratSakit,
                          onChanged:
                              (bool? value) => setState(
                                () =>
                                    _controller.terbitSuratSakit =
                                        value ?? false,
                              ),
                        ),

                        if (_controller.terbitSuratSakit)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: TextField(
                              controller: _controller.lamaSakitController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Lama Istirahat (Jumlah Hari)",
                                hintText: "Contoh: 5",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.medisPrimary,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: _eksekusiSimpanRM,
                      child: const Text(
                        'SIMPAN DATA',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
