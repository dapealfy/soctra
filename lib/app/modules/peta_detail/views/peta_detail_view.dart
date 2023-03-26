import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/peta_detail_controller.dart';

class PetaDetailView extends GetView<PetaDetailController> {
  final LatLng position;
  const PetaDetailView(this.position, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetaDetailView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'PetaDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
