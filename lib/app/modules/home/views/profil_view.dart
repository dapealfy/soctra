import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:soctra/app/modules/auth/controllers/auth_controller.dart';
import 'package:soctra/app/modules/auth/providers/login_provider.dart';
import 'package:soctra/app/modules/edit_profile/controllers/edit_profile_controller.dart';
import 'package:soctra/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:soctra/app/routes/app_pages.dart';
import 'package:soctra/utils/colors.dart';
import 'package:soctra/widgets/text.dart';

class ProfilView extends GetView {
  const ProfilView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(EditProfileController());
    return GetBuilder<EditProfileController>(
      init: EditProfileController(),
      builder: (c) {
        User user = FirebaseAuth.instance.currentUser!;
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            Map<String, dynamic> data = snapshot.data!.data()!;
            return Scaffold(
              backgroundColor: black,
              body: Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 400,
                                        child: CachedNetworkImage(
                                            imageUrl: data['avatar'],
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          black.withOpacity(0.5),
                                          black,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      CText(
                        data['nama_identitas'],
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      CText(
                        '@' + data['nama_alias'],
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CText(
                        data['status'],
                        color: Colors.white.withOpacity(0.9),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 48),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                CText(
                                  '1.2b',
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                                CText(
                                  'Pengikut',
                                  color: Colors.white,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                CText(
                                  '5',
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                                CText(
                                  'Mengikuti',
                                  color: Colors.white,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                CText(
                                  '2048',
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                                CText(
                                  'Postingan',
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(() => EditProfileView());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Edit Profile',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: SafeArea(
                      child: GestureDetector(
                        onTap: () {
                          Get.bottomSheet(Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.10),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xff434343)
                                                  .withOpacity(0.5)),
                                    ),
                                    onPressed: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        'Pengaturan',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red.withOpacity(0.8)),
                                    ),
                                    onPressed: () {
                                      AuthProvider authProvider =
                                          AuthProvider();
                                      authProvider.signOut();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        'Keluar',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                          ));
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: black.withOpacity(0.85),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
