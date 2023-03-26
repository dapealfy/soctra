import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:soctra/app/modules/story/views/story_view.dart';
import 'package:soctra/utils/colors.dart';
import 'package:soctra/widgets/bubble_story.dart';
import 'package:soctra/widgets/text.dart';

class BerandaView extends GetView {
  const BerandaView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        surfaceTintColor: black.withOpacity(1),
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Future.delayed(Duration(seconds: 2));
        },
        child: Column(
          children: [
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  return snapshot.hasData == false
                      ? Container(
                          color: black,
                          height: 110,
                        )
                      : Container(
                          color: black,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          height: 110,
                          child: Center(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => StoryView());
                                  },
                                  child: BubbleStory(
                                    image: data['avatar'],
                                    nama_alias: data['nama_alias'],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                }),
            Expanded(
                child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                return Container(
                  color: black,
                  child: GestureDetector(
                    onTap: () {
                      // Get.to()
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 390,
                              decoration: BoxDecoration(color: Colors.grey),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://a.cdn-hotels.com/gdcs/production143/d1112/c4fedab1-4041-4db5-9245-97439472cf2c.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 12,
                              left: 0,
                              right: 0,
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
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: black.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    CText(
                                      'daffreri',
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 16),
                                decoration: BoxDecoration(
                                    color: black.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(50)),
                                child: CText(
                                  'Bali, Indonesia',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.favorite_outline,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.chat_outlined,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.share_outlined,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CText(
                                        '12.3k Suka',
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Container(
                                        height: 5,
                                        width: 5,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      CText(
                                        '654 Komentar',
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CText(
                                'Lorem ipsum dolor sit amet, consectetur adipiscin... ',
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              CText(
                                'Lihat selengkapnya',
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              CText(
                                '3 hari lalu',
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
