import 'dart:convert';

import 'package:absensi/app/data/service/api.dart';
import 'package:absensi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../modules/login/user_model.dart';

class AuthController extends GetxController {
  late TextEditingController username;
  late TextEditingController password;
  late String fcmtoken = '';
  var userJson = User().obs;
  var box = GetStorage();

  void login() async {
    if (username.text == "") {
      Get.snackbar("Warning", "Username wajib di isi",
          colorText: Colors.white,
          backgroundColor: Color.fromARGB(255, 235, 61, 61),
          snackPosition: SnackPosition.TOP);
      return;
    }

    if (password.text == "") {
      Get.snackbar("Warning", "Password wajib di isi",
          colorText: Colors.white,
          backgroundColor: Color.fromARGB(255, 235, 61, 61),
          snackPosition: SnackPosition.TOP);
      return;
    }

    final response = await http.post(Uri.parse(BaseUrl.login),
        body: {"username": username.text, "password": password.text});
    final data = jsonDecode(response.body);

    if (data['value'] == 0) {
      Get.snackbar("Warning", "Maaf login gagal.",
          colorText: Colors.white,
          backgroundColor: Color.fromARGB(255, 235, 61, 61),
          snackPosition: SnackPosition.TOP);
      return;
    } else {
      Get.snackbar("Warning", "Login anda berhasil. ",
          colorText: Colors.white,
          backgroundColor: Color.fromARGB(255, 112, 224, 116),
          snackPosition: SnackPosition.TOP);

      final box = GetStorage();
      userJson.value = User.fromJson(data['user']);

      print(jsonEncode(userJson.value));
      getFCMToken(userJson.value.nik);
      box.write('user_id', userJson.value.userId);
      box.write('nama', userJson.value.nama);
      box.write('jabatan', userJson.value.jabatan);
      box.write('nik', userJson.value.nik);
      box.write('nama_kantor', userJson.value.namaKantor);
      box.write('alamat_kantor', userJson.value.alamatKantor);
      box.write('isAuth', true);
      Get.offNamed(Routes.HOME);
      refresh();
      update();
    }
  }

  logout() {
    box.write('user_id', '');
    box.write('nama', '');
    box.write('jabatan', '');
    box.write('nik', '');
    box.write('nama_kantor', '');
    box.write('alamat_kantor', '');
    box.write('isAuth', false);
    Get.offAllNamed(Routes.LOGIN);
  }

  void getFCMToken(nik) async {
    var status = await OneSignal.shared.getDeviceState();
    print(status!.userId);
    fcmtoken = status.userId.toString();
    final response = await http.post(Uri.parse(BaseUrl.updatefcmtoken),
        body: {"fcmtoken": fcmtoken, "nik": nik});
    final data = jsonDecode(response.body);

    print(data);
  }

  @override
  void onInit() {
    username = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }
}
