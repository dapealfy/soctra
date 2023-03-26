import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:soctra/app/modules/auth/controllers/auth_controller.dart';
import 'package:soctra/utils/colors.dart';
import 'package:soctra/widgets/text.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                Map<String, dynamic> data = snapshot.data!.data()!;
                controller.setData(
                    data['status'], data['nama_identitas'], data['nama_alias']);
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 280,
                                    child: CachedNetworkImage(
                                        imageUrl: data['avatar'],
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 16,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.getImage();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: black.withOpacity(0.85),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CText(
                                'Status',
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
                                  controller: controller.status,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    hintText: 'yourstatus',
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
                                  controller: controller.namaIdentitas,
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
                                  controller: controller.namaAlias,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    hintText: 'yourname',
                                  ),
                                ),
                              ),
                              SizedBox(height: 28),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 12,
                      left: 18,
                      right: 18,
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).colorScheme.primary),
                              ),
                              onPressed: () {
                                GetStorage box = GetStorage();
                                String uid = box.read('uid') ?? '';
                                final db = FirebaseFirestore.instance;
                                db.collection('users').doc(uid).update(
                                  {
                                    'status': controller.status.text,
                                    'nama_identitas':
                                        controller.namaIdentitas.text,
                                    'nama_alias': controller.namaAlias.text,
                                  },
                                );
                                Get.back();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  'Simpan',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: black.withOpacity(0.85),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
