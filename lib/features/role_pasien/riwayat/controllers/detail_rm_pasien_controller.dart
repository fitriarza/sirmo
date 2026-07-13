import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/network/api_constants.dart';

class DetailRmPasienController {
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  
  Map<String, dynamic> dataDetail = {};
  List<dynamic> listObat = [];

  Future<void> fetchDetailRM(String idRm) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.getDetailRm), // Pastikan ini sudah ditambahkan di ApiConstants
        headers: {"Content-Type": "application/json"},
        body: json.encode({'id_rm': idRm}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          dataDetail = data;
          listObat = data['obat'] ?? [];
        }
      }
    } catch (e) {
      debugPrint("Error Detail RM: $e");
    }
    isLoading.value = false;
  }
}