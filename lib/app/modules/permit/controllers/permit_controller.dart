import 'dart:convert';

import 'package:absensi/app/data/service/api.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PermitController extends GetxController {
  final box = GetStorage();
  var listData = [].obs;

  Future listPermit(String date) async {
    final response = await http.post(Uri.parse(BaseUrl.datapermit),
        body: {"nik": box.read('nik'), "date": date});
    final data = jsonDecode(response.body);
    listData.value = data['results'];
  }

  @override
  void onInit() async {
    var tanggal = DateFormat("yyyy-MM-dd").format(DateTime.now());
    await listPermit(tanggal);
    super.onInit();
  }
}
