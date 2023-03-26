import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_post_controller.dart';

class DetailPostView extends GetView<DetailPostController> {
  const DetailPostView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailPostView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'DetailPostView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
