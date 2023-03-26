import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:soctra/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return GetMaterialApp(
        title: "Soctra",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightDynamic ??
                ColorScheme.fromSwatch(primarySwatch: Colors.blue),
            fontFamily: 'PlusJakartaSans',
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Color(0xff434343),
            ),
            splashFactory: NoSplash.splashFactory),
        darkTheme: ThemeData(
            colorScheme: darkDynamic ??
                ColorScheme.fromSwatch(
                    primarySwatch: Colors.purple, brightness: Brightness.dark),
            useMaterial3: true,
            fontFamily: 'PlusJakartaSans',
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Color(0xff434343),
            ),
            splashFactory: NoSplash.splashFactory),
        themeMode: ThemeMode.dark,
      );
    }),
  );
}
