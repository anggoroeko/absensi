import 'dart:async';
import 'dart:convert';
import 'package:absensi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../data/service/api.dart';
import '../../absensi/views/absensi_view.dart';

class InputabsenController extends GetxController {
  var jam = ''.obs;
  Position? currentPosition;
  var currentLocationAddress = ''.obs;
  var longtitude = ''.obs;
  var latitude = ''.obs;
  var box = GetStorage();

  void startJam() {
    Timer.periodic(Duration(seconds: 1), (_) {
      var tgl = DateTime.now();
      var formatedjam = DateFormat.Hms().format(tgl);
      jam.value = formatedjam;
    });
  }

  void inputAbsen(String flag) async {
    final response = await http.post(Uri.parse(BaseUrl.inputabsen),
        body: {"nik": box.read('nik'), "flag": flag});
    final data = jsonDecode(response.body);
    int value = int.parse(data['value']);
    if (value == 0) {
      Get.snackbar("Warning", data['message'],
          colorText: Colors.white,
          backgroundColor: Color.fromARGB(255, 235, 61, 61),
          snackPosition: SnackPosition.TOP);
    } else {
      Get.snackbar("Selamat", "Proses Absensi berhasil. ",
          colorText: Colors.white,
          backgroundColor: Color.fromARGB(255, 112, 224, 116),
          snackPosition: SnackPosition.TOP);
      Get.offNamed(Routes.INPUTABSEN);
    }
  }

  getCurrentLocation() async {
    // ignore: unused_local_variable
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      currentPosition = position;
      print("RAMELAN");
      getCurrentLocationAddress();
    }).catchError((e) {
      print(e);
    });
  }

  getCurrentLocationAddress() async {
    try {
      print('PAMUJI');
      print(currentPosition!.latitude);
      print(currentPosition!.longitude);
      latitude.value = currentPosition!.latitude.toString();
      longtitude.value = currentPosition!.longitude.toString();
      List<Placemark> listPlaceMarks = await placemarkFromCoordinates(
          currentPosition!.latitude, currentPosition!.longitude);
      Placemark place = listPlaceMarks[0];
      currentLocationAddress.value =
          '${place.locality}, ${place.postalCode}, ${place.country}';

      print(currentLocationAddress.value);
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    startJam();
    getCurrentLocation();
    super.onInit();
  }
}
