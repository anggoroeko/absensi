import 'package:absensi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/appbarpage.dart';
import '../../../utils/userCard.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          AppBarPage(
            name: 'Pengaturan',
          ),
          SizedBox(
            height: 20,
          ),
          UserCardPage(),
          SizedBox(
            height: 40,
          ),
          InkWell(
            onTap: () => Get.toNamed(Routes.UBAHPASSWORD),
            child: ListTile(
              leading: Icon(
                Icons.password,
                color: Colors.blue,
              ),
              title: Text('Ubah Password'),
              trailing: Icon(
                Icons.arrow_right_outlined,
                size: 40,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.book,
              color: Colors.blue,
            ),
            title: Text('Panduan aplikasi'),
            trailing: Icon(
              Icons.arrow_right_outlined,
              size: 40,
            ),
          )
        ],
      ),
    ));
  }
}
