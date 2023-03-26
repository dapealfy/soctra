import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:soctra/app/modules/pesan/providers/chat_provider.dart';
import 'package:soctra/utils/colors.dart';
import 'package:soctra/widgets/text.dart';

import '../controllers/pesan_controller.dart';

class PesanView extends GetView<PesanController> {
  const PesanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: GetBuilder<PesanController>(
              init: PesanController(),
              builder: (c) {
                return Container(
                  transform: Matrix4.translationValues(-14, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: c.peerAvatar,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CText(
                                c.peerName,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              CText(
                                '@' + c.peerNameAlias,
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.video_call),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.call),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert),
            ),
          ],
          centerTitle: false,
        ),
      ),
      body: GetBuilder<PesanController>(
          init: PesanController(),
          builder: (c) {
            return WillPopScope(
              onWillPop: c.onBackPress,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/background_chat.png'),
                )),
                child: Column(
                  children: [
                    Expanded(
                      child: GetBuilder<PesanController>(
                          init: PesanController(),
                          builder: (c) {
                            return c.groupChatId.isNotEmpty
                                ? StreamBuilder<QuerySnapshot>(
                                    stream: c.chatProvider
                                        .getChatStream(c.groupChatId, c.limit),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        c.listMessage = snapshot.data!.docs;
                                        if (c.listMessage.length > 0) {
                                          return ListView.builder(
                                            padding: EdgeInsets.all(10),
                                            itemBuilder: (context, index) =>
                                                c.buildItem(
                                                    index,
                                                    snapshot.data?.docs[index],
                                                    context),
                                            itemCount:
                                                snapshot.data?.docs.length,
                                            reverse: true,
                                            controller: c.listScrollController,
                                          );
                                        } else {
                                          return Center(
                                              child: Text(
                                                  "Belum ada pesan disini..."));
                                        }
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        );
                                      }
                                    },
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  );
                          }),
                    ),
                    GetBuilder<PesanController>(
                      init: PesanController(),
                      builder: (c) {
                        return c.isShowSticker
                            ? c.buildSticker(context)
                            : SizedBox.shrink();
                      },
                    ),
                    GetBuilder<PesanController>(
                        init: PesanController(),
                        builder: (c) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 18),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    focusNode: c.focusNode,
                                    controller: c.textEditingController,
                                    decoration: InputDecoration(
                                      fillColor: black,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: black, width: 0.0),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: black, width: 0.0),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintText: 'Ketik Pesan',
                                      prefixIcon: IconButton(
                                        icon: Icon(Icons.insert_emoticon),
                                        onPressed: () {
                                          c.getSticker();
                                        },
                                      ),
                                      suffixIcon: c.showSuffix == false
                                          ? null
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  transform:
                                                      Matrix4.translationValues(
                                                          8, 0, 0),
                                                  child: IconButton(
                                                    icon:
                                                        Icon(Icons.attach_file),
                                                    onPressed: () {
                                                      c.getImage();
                                                    },
                                                  ),
                                                ),
                                                IconButton(
                                                  icon:
                                                      Icon(Icons.photo_camera),
                                                  onPressed: () {
                                                    c.getPhoto();
                                                  },
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 60,
                                  child: FloatingActionButton(
                                    shape: CircleBorder(),
                                    onPressed: () {
                                      c.onSendMessage(
                                          c.textEditingController.text, 0);
                                    },
                                    child: Icon(Icons.send),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
