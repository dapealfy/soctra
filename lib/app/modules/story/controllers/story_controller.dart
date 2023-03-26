import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryController extends GetxController {
  final FocusNode focusNode = FocusNode();
  bool focus = false;

  void onFocusChange() {
    if (focusNode.hasFocus) {
      focus = true;
    } else {
      focus = false;
    }
    update();
  }

  Future<bool> onBackPress() {
    focusNode.unfocus();
    update();
    Get.back();

    return Future.value(false);
  }

  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(onFocusChange);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
