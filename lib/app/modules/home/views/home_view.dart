import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:soctra/utils/colors.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: black,
    ));
    Get.put(HomeController());
    return Scaffold(
      body: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (c) {
          return c.pages.elementAt(c.selectedIndex);
        },
      ),
      bottomNavigationBar: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (c) {
            return NavigationBarTheme(
              data: NavigationBarThemeData(
                  indicatorColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  iconTheme: MaterialStateProperty.all(
                    IconThemeData(
                      color: Colors.white,
                    ),
                  )),
              child: NavigationBar(
                backgroundColor: black,
                onDestinationSelected: (int index) {
                  c.setSelectedIndex(index);
                },
                selectedIndex: c.selectedIndex,
                destinations: const <NavigationDestination>[
                  NavigationDestination(
                    selectedIcon: Icon(Icons.home),
                    icon: Icon(Icons.home_outlined),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.map),
                    icon: Icon(Icons.map_outlined),
                    label: 'Peta',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.chat),
                    icon: Icon(Icons.chat_outlined),
                    label: 'Pesan',
                  ),
                  NavigationDestination(
                    selectedIcon: Icon(Icons.person),
                    icon: Icon(Icons.person_outline),
                    label: 'Profil',
                  ),
                ],
              ),
            );
          }),
    );
  }
}
