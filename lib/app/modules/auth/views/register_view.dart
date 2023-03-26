import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:soctra/widgets/text.dart';

class RegisterView extends GetView {
  const RegisterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff141414),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/onboard.png',
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Color(0xff141414).withOpacity(0.7),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CText(
                          'Daftar',
                          fontSize: 32,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        CText(
                          'Email',
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
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              hintText: 'yourmail@mail.com',
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        CText(
                          'Nama Identitas',
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
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              hintText: 'yourid',
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        CText(
                          'Nama Alias',
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
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              hintText: 'yourname',
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
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              hintText: '********',
                              suffixIcon: Icon(
                                Icons.visibility_outlined,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        CText(
                          'Konfirmasi Kata Sandi',
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
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              hintText: '********',
                              suffixIcon: Icon(
                                Icons.visibility_outlined,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      Theme.of(context).colorScheme.primary),
                                ),
                                onPressed: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    'Daftar',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 28),
                        Center(
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Sudah punya akun? ',
                                style: TextStyle(color: Color(0xff737373))),
                            TextSpan(
                                text: 'Masuk Sekarang',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Get.back(),
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
            ),
          ),
        ],
      ),
    );
  }
}
