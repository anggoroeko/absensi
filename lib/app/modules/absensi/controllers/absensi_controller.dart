import 'dart:convert';

import 'package:absensi/app/data/service/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AbsensiController extends GetxController {
  final box = GetStorage();
  var listData = [].obs;
  bool isLoading = false;

  Future listAbsensi() async {
    final response = await http
        .post(Uri.parse(BaseUrl.absen), body: {"nik": box.read('nik')});
    final data = jsonDecode(response.body);
    listData.value = data['results'];
  }

  Future<void> alertDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          titleTextStyle: TextStyle(color: Colors.black),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Apakah anda yakin !!!.',
                  style: TextStyle(fontSize: 13.0),
                ),
                // Text('You\’re like me. I’m never satisfied.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : callabsen();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  callabsen() async {
    if (!isLoading) {
      isLoading = true;

      final response = await http
          .post(Uri.parse(BaseUrl.callabsen), body: {"nik": box.read('nik')});
      final data = jsonDecode(response.body);
      int value = data['value'];
      String pesan = data['message'];
      if (value == 1) {
        Get.snackbar("Success", "Proses Syncronice Berhasil",
            colorText: Colors.white,
            backgroundColor: Color.fromARGB(255, 112, 224, 116),
            snackPosition: SnackPosition.TOP);
        await listAbsensi();
      } else {
        Get.snackbar("Warning", pesan,
            colorText: Colors.white,
            backgroundColor: Color.fromARGB(255, 235, 61, 61),
            snackPosition: SnackPosition.TOP);
      }
    }
  }

  @override
  void onInit() async {
    await listAbsensi();
    super.onInit();
  }
}
