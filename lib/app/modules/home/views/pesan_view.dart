import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:soctra/app/modules/pesan/controllers/pesan_controller.dart';
import 'package:soctra/app/routes/app_pages.dart';
import 'package:soctra/utils/colors.dart';
import 'package:soctra/widgets/text.dart';

class PesanView extends GetView {
  const PesanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: black,
        appBar: AppBar(
          backgroundColor: black,
          title: const Text(
            'Pesan',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add_ic_call_outlined,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
              ),
            )
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        User user = FirebaseAuth.instance.currentUser!;
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return document.id == user.uid
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  final PesanController pesanController =
                                      Get.put(PesanController());
                                  pesanController.setPeerId(
                                      document.id,
                                      data['nama_identitas'],
                                      data['nama_alias'],
                                      data['avatar']);
                                  Get.toNamed(Routes.PESAN);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              shape: BoxShape.circle,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: CachedNetworkImage(
                                                imageUrl: data['avatar'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CText(
                                                data['nama_identitas'],
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              GetBuilder<PesanController>(
                                                init: PesanController(),
                                                builder: (c) {
                                                  GetStorage box = GetStorage();
                                                  String currentUserId =
                                                      box.read('uid');
                                                  String groupChatId = '';
                                                  String peerId = document.id;

                                                  if (currentUserId
                                                          .compareTo(peerId) >
                                                      0) {
                                                    groupChatId =
                                                        '$currentUserId-$peerId';
                                                  } else {
                                                    groupChatId =
                                                        '$peerId-$currentUserId';
                                                  }
                                                  return StreamBuilder<
                                                          QuerySnapshot>(
                                                      stream: c.chatProvider
                                                          .getLastMessage(
                                                              groupChatId),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                        if (snapshot.hasData) {
                                                          return CText(
                                                            snapshot.data?.docs
                                                                        .isEmpty ==
                                                                    true
                                                                ? 'Mulai chat..'
                                                                : snapshot.data?.docs[0]
                                                                            [
                                                                            'type'] ==
                                                                        2
                                                                    ? '📷  Photo'
                                                                    : snapshot
                                                                            .data
                                                                            ?.docs[0]
                                                                        [
                                                                        'content'],
                                                            color: Colors.grey,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          );
                                                        } else {
                                                          return CText(
                                                            'Mulai chat..',
                                                            color: Colors.grey,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          );
                                                        }
                                                      });
                                                },
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      }).toList(),
                    )
                  : Center();
            }));
  }
}
