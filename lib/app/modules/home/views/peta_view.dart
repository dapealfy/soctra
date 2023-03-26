import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_animated_marker/flutter_map_animated_marker.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:soctra/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:soctra/app/modules/home/controllers/home_controller.dart';
import 'package:soctra/app/modules/home/views/profil_view.dart';
import 'package:soctra/app/modules/pesan/controllers/pesan_controller.dart';
import 'package:soctra/app/modules/peta_detail/views/peta_detail_view.dart';
import 'package:soctra/app/routes/app_pages.dart';
import 'package:soctra/utils/colors.dart';
import 'package:soctra/utils/env.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:soctra/widgets/text.dart';

class PetaView extends GetView {
  const PetaView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: [
          GetBuilder<HomeController>(
              init: HomeController(),
              initState: (state) {
                User user = FirebaseAuth.instance.currentUser!;

                final LocationSettings locationSettings = AndroidSettings(
                    accuracy: LocationAccuracy.high,
                    distanceFilter: 100,
                    forceLocationManager: true,
                    intervalDuration: const Duration(seconds: 1),
                    foregroundNotificationConfig:
                        const ForegroundNotificationConfig(
                      notificationText:
                          "Soctra mengakses lokasimu secara realtime",
                      notificationTitle: "Running in Background",
                      enableWakeLock: true,
                    ));

                Geolocator.getPositionStream(locationSettings: locationSettings)
                    .listen((Position position) {
                  final db = FirebaseFirestore.instance;
                  GetStorage box = GetStorage();
                  String uid = box.read('uid') ?? '';
                  if (uid != '') {
                    db.collection('users').doc(uid).update(
                      {
                        'lat': position.latitude.toString(),
                        'lng': position.longitude.toString()
                      },
                    );
                  }
                });
              },
              builder: (c) {
                User user = FirebaseAuth.instance.currentUser!;
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.hasData == false
                          ? Container()
                          : FlutterMap(
                              options: MapOptions(
                                  // onLongPress: (tap, position) {

                                  // Get.to(PetaDetailView(position));
                                  // },
                                  minZoom: 5,
                                  maxZoom: 18,
                                  zoom: 13,
                                  center: LatLng(c.getCurrentPosition!.latitude,
                                      c.getCurrentPosition!.longitude),
                                  interactiveFlags: InteractiveFlag.pinchZoom |
                                      InteractiveFlag.drag,
                                  plugins: [
                                    AnimatedMarkerPlugin(),
                                  ]),
                              layers: [
                                TileLayerOptions(
                                  urlTemplate:
                                      "https://api.mapbox.com/styles/v1/davearr/clcrnx2li000214r0quwyn5jt/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
                                  additionalOptions: {
                                    'accessToken':
                                        AppConstants.mapBoxAccessToken,
                                  },
                                ),
                                MarkerLayerOptions(
                                  markers: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    return Marker(
                                      point: LatLng(double.parse(data['lat']),
                                          double.parse(data['lng'])),
                                      width: 74,
                                      height: 74,
                                      builder: (context) => GestureDetector(
                                        onTap: () {
                                          Get.bottomSheet(
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(20),
                                                ),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 24),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    Container(
                                                      height: 4,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primaryContainer,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 24,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 64,
                                                          width: 64,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.grey,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: data[
                                                                  'avatar'],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 12,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CText(
                                                              data[
                                                                  'nama_identitas'],
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                            SizedBox(
                                                              height: 2,
                                                            ),
                                                            CText(
                                                              '@' +
                                                                  data[
                                                                      'nama_alias'],
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 24,
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 24),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              CText(
                                                                '1.2b',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              CText(
                                                                'Pengikut',
                                                                color: Colors
                                                                    .white,
                                                              )
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              CText(
                                                                '5',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              CText(
                                                                'Mengikuti',
                                                                color: Colors
                                                                    .white,
                                                              )
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              CText(
                                                                '2048',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              CText(
                                                                'Postingan',
                                                                color: Colors
                                                                    .white,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 32,
                                                    ),
                                                    user.uid == document.id
                                                        ? Container()
                                                        : Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 10),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          16.0),
                                                                      child:
                                                                          Text(
                                                                        'Panggil',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Get.back();
                                                                      final PesanController
                                                                          pesanController =
                                                                          Get.put(
                                                                              PesanController());
                                                                      pesanController.setPeerId(
                                                                          document
                                                                              .id,
                                                                          data[
                                                                              'nama_identitas'],
                                                                          data[
                                                                              'nama_alias'],
                                                                          data[
                                                                              'avatar']);
                                                                      Get.toNamed(
                                                                          Routes
                                                                              .PESAN);
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          16.0),
                                                                      child:
                                                                          Text(
                                                                        'Pesan',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                    TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                          Get.to(() =>
                                                              ProfilView());
                                                        },
                                                        child: Text(
                                                            'Lihat Profil')),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 64,
                                                width: 64,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: user.uid ==
                                                                document.id
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .primary
                                                            : Colors.white,
                                                        width: 4),
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.32),
                                                        blurRadius: 16,
                                                      ),
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.16),
                                                        blurRadius: 24,
                                                      ),
                                                    ]),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: CachedNetworkImage(
                                                    imageUrl: data['avatar'],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                    });
              }),
          Positioned(
            bottom: 16,
            right: 16,
            child: GetBuilder<HomeController>(
                init: HomeController(),
                builder: (c) {
                  return FloatingActionButton(
                    backgroundColor: c.locationOn == true
                        ? null
                        : Theme.of(context).colorScheme.background,
                    onPressed: () {
                      // c.setGpsStatus(!c.locationOn);
                    },
                    child: Icon(c.locationOn == true
                        ? Icons.location_on
                        : Icons.location_off),
                  );
                }),
          )
        ],
      ),
    );
  }
}
