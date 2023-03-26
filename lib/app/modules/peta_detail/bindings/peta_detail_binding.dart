import 'package:get/get.dart';

import '../controllers/peta_detail_controller.dart';

class PetaDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetaDetailController>(
      () => PetaDetailController(),
    );
  }
}
