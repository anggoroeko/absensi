import 'dart:convert';

import 'package:absensi/app/data/service/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class UbahpasswordController extends GetxController {
  late TextEditingController passwordlama;
  late TextEditingController passwordbaru;
  late TextEditingController passwordconfirm;
  final box = GetStorage();

  void ubahPassword() async {
    if (passwordlama.text == "") {
      Get.snackbar("Warning", "Password lama wajib di isi",
          colorText: Colors.white,
          backgroundColor: Color.fromARGB(255, 235, 61, 61),
          snackPosition: SnackPosition.TOP);
      return;
    }

    if (passwordbaru.text == "") {
      Get.snackbar("Warning", "Password baru wajib di isi",
          colorText: Colors.white,
          backgroundColor: Color.fromARGB(255, 235, 61, 61),
          snackPosition: SnackPosition.TOP);
      return;
    }

    if (passwordconfirm.text == "") {
      Get.snackbar("Warning", "Password confirm  wajib di isi",
          colorText: Colors.white,
          backgroundColor: Color.fromARGB(255, 235, 61, 61),
          snackPosition: SnackPosition.TOP);
      return;
    }

    if (passwordconfirm.text != passwordbaru.text) {
      Get.snackbar("Warning", "Password baru dan password confirm tidak sama",
          colorText: Colors.white,
          backgroundColor: Color.fromARGB(255, 235, 61, 61),
          snackPosition: SnackPosition.TOP);
      return;
    }

    final response = await http.post(Uri.parse(BaseUrl.gantipassword), body: {
      "nik": box.read('nik'),
      "passwordlama": passwordlama.text,
      "passwordbaru": passwordbaru.text,
      "passwordconfirm": passwordconfirm.text
    });
    final data = jsonDecode(response.body);

    if (data['value'] == 0) {
      Get.snackbar("Warning", "Ubah password gagal.",
          colorText: Colors.white,
          backgroundColor: Color.fromARGB(255, 235, 61, 61),
          snackPosition: SnackPosition.TOP);
      return;
    } else {
      Get.snackbar("Warning", "Ubah password berhasil. ",
          colorText: Colors.white,
          backgroundColor: Color.fromARGB(255, 112, 224, 116),
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  void onInit() {
    passwordlama = TextEditingController();
    passwordbaru = TextEditingController();
    passwordconfirm = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    passwordbaru.dispose();
    passwordlama.dispose();
    passwordconfirm.dispose();
    super.dispose();
  }
}
