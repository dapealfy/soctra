import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:soctra/utils/colors.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
      backgroundColor: black,
      body: Center(),
    );
  }
}
