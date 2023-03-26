import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  TextEditingController status = TextEditingController();
  TextEditingController namaIdentitas = TextEditingController();
  TextEditingController namaAlias = TextEditingController();
  File? imageFile;
  String imageUrl = '';

  setData(_status, _namaIdentitas, _namaAlias) {
    status.text = _status;
    namaIdentitas.text = _namaIdentitas;
    namaAlias.text = _namaAlias;
    update();
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 640);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        update();
        uploadFile();
      }
    }
  }

  UploadTask uploadFileTask(File image, String fileName) {
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future uploadFile() async {
    GetStorage box = GetStorage();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = uploadFileTask(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      String uid = box.read('uid') ?? '';
      final db = FirebaseFirestore.instance;
      db.collection('users').doc(uid).update(
        {
          'avatar': imageUrl,
        },
      );
      update();
    } on FirebaseException catch (e) {
      update();
      Get.dialog(AlertDialog(
        title: Text('Terjadi Kesalahan'),
        content: Text(e.toString()),
      ));
    }
  }

  @override
  void onInit() {
    super.onInit();
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
