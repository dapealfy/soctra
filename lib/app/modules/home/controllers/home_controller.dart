import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:soctra/app/modules/home/views/beranda_view.dart';
import 'package:soctra/app/modules/home/views/pesan_view.dart';
import 'package:soctra/app/modules/home/views/peta_view.dart';
import 'package:soctra/app/modules/home/views/profil_view.dart';
import 'package:soctra/app/modules/pesan/providers/chat_provider.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  int selectedIndex = 0;
  bool locationOn = true;
  List<Widget> pages = [
    BerandaView(),
    PetaView(),
    PesanView(),
    ProfilView(),
  ];

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Position? getCurrentPosition;

  void determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    getCurrentPosition = await Geolocator.getCurrentPosition();
    final db = FirebaseFirestore.instance;
    GetStorage box = GetStorage();
    String uid = box.read('uid') ?? '';
    if (uid != '') {
      db.collection('users').doc(uid).update(
        {
          'lat': getCurrentPosition!.latitude.toString(),
          'lng': getCurrentPosition!.longitude.toString()
        },
      );
    }
    update();
  }

  void registerNotification() {
    firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      if (message.notification != null) {
        Get.snackbar(message.notification!.title!, message.notification!.body!,
            titleText: Text('woi'));
      }
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('push token: $token');
      GetStorage box = GetStorage();
      if (token != null) {
        ChatProvider chatProvider = ChatProvider(
            firebaseFirestore: FirebaseFirestore.instance,
            firebaseStorage: FirebaseStorage.instance);
        chatProvider.updateDataFirestore(
            'users', box.read('uid'), {'pushToken': token});
      }
    }).catchError((err) {
      Get.dialog(AlertDialog(
          title: Text('Terjadi Error'), content: Text(err.toString())));
    });
  }

  setSelectedIndex(index) {
    selectedIndex = index;
    update();
  }

  setGpsStatus(status) {
    locationOn = status;
    update();
  }

  @override
  void onInit() {
    determinePosition();
    registerNotification();
    super.onInit();
  }
}
