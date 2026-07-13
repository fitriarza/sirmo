import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CetakSuratView extends StatelessWidget {
  final Map<String, dynamic> data;

  const CetakSuratView({super.key, required this.data});

  Future<Uint8List> _generatePdf(PdfPageFormat format, String titleDocument) async {
    final pdf = pw.Document(title: titleDocument, author: 'Sistem SIRMO');

    // 🟢 EKSTRAK SEMUA DATA YANG DIKIRIM
    final String namaPasien = data['nama_pasien'] ?? 'Tanpa Nama';
    final String tglPeriksa = data['tanggal'] ?? "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
    final String namaDokter = data['nama_dokter'] ?? 'Tenaga Medis';
    final String lamaIstirahat = data['lama_istirahat'] ?? '3 Hari';
    final String diagnosa = data['diagnosa'] ?? '-';
    
    final String namaKlinik = data['nama_klinik'] ?? 'Nama Klinik Tidak Tersedia';
    final String alamatKlinik = data['alamat_klinik'] ?? 'Alamat Belum Diatur';
    final String kotaKlinik = data['kota_klinik'] ?? '-';

    final String tglCetak = "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.symmetric(horizontal: 35, vertical: 30),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ================= KOP SURAT =================
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      namaKlinik.toUpperCase(), // 🟢 NAMA KLINIK DINAMIS
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      "Pelayanan Rekam Medis & Kesehatan Terpadu",
                      style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      alamatKlinik, // 🟢 ALAMAT DINAMIS
                      style: const pw.TextStyle(fontSize: 9, color: PdfColors.black),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Divider(thickness: 2, color: PdfColors.black),
              pw.Divider(thickness: 0.5, color: PdfColors.black),
              pw.SizedBox(height: 15),

              // ================= JUDUL SURAT =================
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      "SURAT KETERANGAN SAKIT",
                      style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      "Nomor: 440/RM-SRM/${DateTime.now().month}/${DateTime.now().year}",
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 25),

              // ================= ISI SURAT =================
              pw.Text(
                "Yang bertanda tangan di bawah ini menerangkan dengan sesungguhnya bahwa:",
                style: const pw.TextStyle(fontSize: 11),
                textAlign: pw.TextAlign.justify,
              ),
              pw.SizedBox(height: 12),

              // BIODATA DINAMIS
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 10),
                child: pw.Table(
                  columnWidths: {
                    0: const pw.FixedColumnWidth(90),
                    1: const pw.FixedColumnWidth(15),
                    2: const pw.FlexColumnWidth(),
                  },
                  children: [
                    _buildRowBiodata("Nama Pasien", namaPasien),
                    _buildRowBiodata("Tgl. Pemeriksaan", tglPeriksa),
                    _buildRowBiodata("Diagnosa", diagnosa),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),

              pw.Text(
                "Berdasarkan hasil pemeriksaan medis, pasien tersebut di atas dalam keadaan sakit dan memerlukan istirahat selama:",
                style: const pw.TextStyle(fontSize: 11),
                textAlign: pw.TextAlign.justify,
              ),
              pw.SizedBox(height: 15),

              // ================= BOX LAMA ISTIRAHAT =================
              pw.Center(
                child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    border: pw.Border.all(color: PdfColors.grey400, width: 1.5),
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Text(
                    lamaIstirahat,
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, letterSpacing: 1),
                  ),
                ),
              ),
              pw.SizedBox(height: 15),

              pw.Text(
                "Demikian surat keterangan ini diberikan agar dapat dipergunakan sebagaimana mestinya.",
                style: const pw.TextStyle(fontSize: 11),
                textAlign: pw.TextAlign.justify,
              ),

              pw.Spacer(),

              // ================= TANDA TANGAN =================
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        "$kotaKlinik, $tglCetak", // 🟢 KOTA DINAMIS
                        style: const pw.TextStyle(fontSize: 11),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text("Pemeriksa,", style: const pw.TextStyle(fontSize: 11)),
                      pw.SizedBox(height: 55),
                      pw.Text(
                        namaDokter,
                        style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.TableRow _buildRowBiodata(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: pw.Text(label, style: const pw.TextStyle(fontSize: 11)),
        ),
        pw.Text(":", style: const pw.TextStyle(fontSize: 11)),
        pw.Text(value, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String namaPasien = data['nama_pasien'] ?? 'Pasien';
    String tanggal = data['tanggal']?.replaceAll('-', '') ?? '0000';
    String namaFileCustom = "Surat_Sakit_${namaPasien}_$tanggal.pdf";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cetak Surat Sakit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format, namaFileCustom),
        pdfFileName: namaFileCustom,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
      ),
    );
  }
}