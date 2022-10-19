import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../utils/appbarpage.dart';
import '../controllers/inputabsen_controller.dart';

class InputabsenView extends GetView<InputabsenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppBarPage(
                name: 'Input Absen',
              ),
              Container(
                padding: EdgeInsets.only(top: 30, left: 30),
                child: Obx(
                  () => (controller.jam.value.isEmpty)
                      ? CircularProgressIndicator()
                      : Text(
                          'Jam : ' + controller.jam.value,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              SizedBox(
                width: 15,
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Stack(
              children: [
                Obx(
                  () => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: controller.latitude.value == '' ||
                                  controller.longtitude.value == ''
                              ? Center(
                                  child: InkWell(
                                    onTap: () =>
                                        controller.getCurrentLocation(),
                                    child: Container(
                                      width: 150,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Center(
                                          child: Text(
                                        'GET LOKASI ANDA',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                )
                              : GoogleMap(
                                  mapType: MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        double.parse(controller.latitude.value),
                                        double.parse(
                                            controller.longtitude.value)),
                                    zoom: 16.0,
                                  ),
                                  markers: <Marker>{
                                    Marker(
                                      markerId: MarkerId(
                                          "${controller.latitude.value}, ${controller.longtitude.value}"),
                                      position: LatLng(
                                          double.parse(
                                              controller.latitude.value),
                                          double.parse(
                                              controller.longtitude.value)),
                                      icon: BitmapDescriptor.defaultMarker,
                                    )
                                  },
                                  circles: <Circle>{
                                    Circle(
                                      circleId: CircleId("0"),
                                      center: LatLng(
                                          double.parse(
                                              controller.latitude.value),
                                          double.parse(
                                              controller.longtitude.value)),
                                      radius: 4000,
                                    )
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () => controller.inputAbsen("MASUK"),
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                      child: Text(
                    'IN',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              InkWell(
                onTap: () => controller.inputAbsen("KELUAR"),
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                      child: Text(
                    'OUT',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
