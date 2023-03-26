import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soctra/app/modules/auth/views/login_view.dart';
import 'package:soctra/app/modules/home/controllers/home_controller.dart';
import 'package:soctra/app/modules/home/views/home_view.dart';

class AuthController extends GetxController {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  bool obscureText = true;
  User? currentUser;

  setCurrentUser(User? user) {
    currentUser = user;
    update();
  }

  void viewPassword(status) {
    obscureText = status;
    update();
  }

  goToPage() {
    Future.delayed(Duration(seconds: 1), () {
      if (FirebaseAuth.instance.currentUser != null) {
        setCurrentUser(FirebaseAuth.instance.currentUser!);
        Get.off(() => HomeView());
      } else {
        Get.off(() => LoginView());
      }
    });
  }

  @override
  void onInit() {
    goToPage();
    super.onInit();
  }
}
