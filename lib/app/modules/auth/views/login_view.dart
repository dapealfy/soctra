import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:soctra/app/modules/auth/controllers/auth_controller.dart';
import 'package:soctra/app/modules/auth/providers/login_provider.dart';
import 'package:soctra/app/modules/auth/views/register_view.dart';
import 'package:soctra/app/modules/home/views/home_view.dart';
import 'package:soctra/utils/colors.dart';
import 'package:soctra/widgets/text.dart';

class LoginView extends GetView {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: black,
    ));
    return Scaffold(
      backgroundColor: Color(0xff141414),
      body: GetBuilder<AuthController>(
          init: AuthController(),
          builder: (c) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/images/onboard.png',
                      height: 240, fit: BoxFit.cover),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CText(
                          'Masuk',
                          fontSize: 32,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        CText(
                          'Nama User',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 55,
                          child: TextField(
                            controller: c.username,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              hintText: 'yourmail@mail.com',
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        CText(
                          'Kata Sandi',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 55,
                          child: TextField(
                            controller: c.password,
                            obscureText: c.obscureText,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              hintText: '********',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  c.obscureText
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () {
                                  c.viewPassword(!c.obscureText);
                                },
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Lupa Password?',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      Theme.of(context).colorScheme.primary),
                                ),
                                onPressed: () {
                                  final AuthProvider authProvider =
                                      AuthProvider();
                                  authProvider
                                      .signIn(
                                          email: c.username.text,
                                          password: c.password.text)
                                      .then((result) {
                                    if (result is User) {
                                      c.setCurrentUser(result);
                                      Get.off(() => HomeView());
                                    } else {
                                      Get.dialog(AlertDialog(
                                          title: Text('Gagal Login'),
                                          content: Text(result)));
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    'Masuk',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        Center(
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Belum punya akun? ',
                                style: TextStyle(color: Color(0xff737373))),
                            TextSpan(
                                text: 'Buat Akun',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Get.to(() => RegisterView()),
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600)),
                          ])),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
