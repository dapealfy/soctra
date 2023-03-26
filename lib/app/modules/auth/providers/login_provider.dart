import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:soctra/app/modules/auth/views/login_view.dart';

class AuthProvider extends GetConnect {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  Future signIn({String? email, String? password}) async {
    GetStorage box = GetStorage();
    try {
      await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      box.write('uid', user.uid);
      return user;
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future signOut() async {
    GetStorage box = GetStorage();
    box.remove('uid');
    await _auth.signOut();
    Get.offAll(() => LoginView());
  }

  String? getUserFirebaseId() {
    GetStorage box = GetStorage();
    return box.read('uid');
  }
}
