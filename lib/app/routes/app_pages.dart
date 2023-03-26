import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/detail_post/bindings/detail_post_binding.dart';
import '../modules/home/detail_post/views/detail_post_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/pesan/bindings/pesan_binding.dart';
import '../modules/pesan/views/pesan_view.dart';
import '../modules/peta_detail/bindings/peta_detail_binding.dart';
import '../modules/peta_detail/views/peta_detail_view.dart';
import '../modules/story/bindings/story_binding.dart';
import '../modules/story/views/story_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AUTH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.DETAIL_POST,
          page: () => const DetailPostView(),
          binding: DetailPostBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.PESAN,
      page: () => PesanView(),
      binding: PesanBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.STORY,
      page: () => const StoryView(),
      binding: StoryBinding(),
    ),
  ];
}
