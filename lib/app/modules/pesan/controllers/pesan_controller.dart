import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:soctra/app/data/message_chat.dart';
import 'package:soctra/app/modules/auth/providers/login_provider.dart';
import 'package:soctra/app/modules/pesan/constants/chat_firestore.dart';
import 'package:soctra/app/modules/pesan/providers/chat_provider.dart';
import 'package:soctra/utils/colors.dart';
import 'package:soctra/widgets/full_photo.dart';
import 'package:soctra/widgets/text.dart';

class PesanController extends GetxController {
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessage = [];
  int limit = 20;
  int limitIncrement = 20;
  String groupChatId = "";
  String peerId = '';
  String peerName = '';
  String peerNameAlias = '';
  String peerAvatar = '';
  File? imageFile;

  bool isLoading = false;
  bool isShowSticker = false;
  bool showSuffix = true;
  String imageUrl = "";

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  late ChatProvider chatProvider;
  late AuthProvider authProvider;

  setPeerId(peerId_, peerName_, peerNameAlias_, peerAvatar_) {
    peerId = peerId_;
    peerName = peerName_;
    peerNameAlias = peerNameAlias_;
    peerAvatar = peerAvatar_;
    readLocal();
    update();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      isShowSticker = false;
      showSuffix = false;
    } else {
      showSuffix = true;
    }
    update();
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 640);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        isLoading = true;
        update();
        uploadFile();
      }
    }
  }

  Future getPhoto() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile =
        await imagePicker.pickImage(source: ImageSource.camera, maxHeight: 640);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        isLoading = true;
        update();
        uploadFile();
      }
    }
  }

  void getSticker() {
    focusNode.unfocus();
    isShowSticker = !isShowSticker;
    update();
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      isShowSticker = false;
      update();
    } else {
      chatProvider.updateDataFirestore(
        FirestoreConstants.pathUserCollection,
        currentUserId,
        {FirestoreConstants.chattingWith: null},
      );
      Get.back();
    }

    return Future.value(false);
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      isLoading = false;
      onSendMessage(imageUrl, 2);
      update();
    } on FirebaseException catch (e) {
      isLoading = false;
      update();
      Get.dialog(AlertDialog(
        title: Text('Terjadi Kesalahan'),
        content: Text(e.toString()),
      ));
    }
  }

  void readLocal() {
    GetStorage box = GetStorage();
    currentUserId = box.read('uid');

    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }
    update();

    chatProvider.updateDataFirestore(
      FirestoreConstants.pathUserCollection,
      currentUserId,
      {FirestoreConstants.chattingWith: peerId},
    );
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      chatProvider.sendMessage(
          content, type, groupChatId, currentUserId, peerId);
      if (listScrollController.hasClients) {
        listScrollController.animateTo(0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    }
  }

  Widget buildSticker(context) {
    return Container(
      decoration: BoxDecoration(
        color: black,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(horizontal: 14),
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => onSendMessage('gass', 1),
                child: Image.asset(
                  'assets/sticker/gass.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              TextButton(
                onPressed: () => onSendMessage('ok', 1),
                child: Image.asset(
                  'assets/sticker/ok.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              TextButton(
                onPressed: () => onSendMessage('otewe', 1),
                child: Image.asset(
                  'assets/sticker/otewe.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => onSendMessage('punt10', 1),
                child: Image.asset(
                  'assets/sticker/punt10.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              TextButton(
                onPressed: () => onSendMessage('serlok', 1),
                child: Image.asset(
                  'assets/sticker/serlok.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              TextButton(
                onPressed: () => onSendMessage('duar', 1),
                child: Image.asset(
                  'assets/sticker/duar.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot? document, context) {
    if (document != null) {
      MessageChat messageChat = MessageChat.fromDocument(document);
      if (messageChat.idFrom == currentUserId) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    constraints:
                        const BoxConstraints(minWidth: 50, maxWidth: 230),
                    padding: EdgeInsets.symmetric(
                        horizontal: messageChat.type == 2 ? 0 : 10),
                    decoration: BoxDecoration(
                      color: messageChat.type == 1
                          ? Colors.transparent
                          : Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                          right: messageChat.type == 2 ? 0 : 20,
                          bottom: messageChat.type == 2 ? 0 : 25,
                          top: messageChat.type == 2 ? 0 : 8),
                      child: messageChat.type == 1
                          ? Container(
                              child: Image.asset(
                                'assets/sticker/${messageChat.content}.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : messageChat.type == 2
                              ? InkWell(
                                  child: Material(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.network(
                                      messageChat.content,
                                      width: 250,
                                      height: 250,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Container(
                                          width: 250,
                                          height: 250,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, object, stackTrace) {
                                        return Material(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child: Icon(Icons.error),
                                        );
                                      },
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(
                                      () => FullPhotoPage(
                                        url: messageChat.content,
                                      ),
                                    );
                                  },
                                )
                              : Text(messageChat.content),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 5,
                right: 12,
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: messageChat.type != 2
                          ? null
                          : [
                              BoxShadow(
                                color: black.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 10,
                                offset: Offset(5, 5),
                              ),
                            ]),
                  child: Text(
                    // DateFormat('dd MMM kk:mm').format(
                    DateFormat('kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(messageChat.timestamp))),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    constraints:
                        const BoxConstraints(minWidth: 50, maxWidth: 230),
                    padding: EdgeInsets.symmetric(
                        horizontal: messageChat.type == 2 ? 0 : 10),
                    decoration: BoxDecoration(
                      color: messageChat.type == 1
                          ? Colors.transparent
                          : Theme.of(context)
                              .colorScheme
                              .tertiaryContainer
                              .withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                          right: messageChat.type == 2 ? 0 : 20,
                          bottom: messageChat.type == 2 ? 0 : 25,
                          top: messageChat.type == 2 ? 0 : 8),
                      child: messageChat.type == 1
                          ? Container(
                              child: Image.asset(
                                'assets/sticker/${messageChat.content}.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : messageChat.type == 2
                              ? InkWell(
                                  child: Material(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.network(
                                      messageChat.content,
                                      width: 250,
                                      height: 250,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Container(
                                          width: 250,
                                          height: 250,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, object, stackTrace) {
                                        return Material(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child: Icon(Icons.error),
                                        );
                                      },
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(
                                      () => FullPhotoPage(
                                        url: messageChat.content,
                                      ),
                                    );
                                  },
                                )
                              : Text(messageChat.content),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 12,
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: messageChat.type != 2
                              ? null
                              : [
                                  BoxShadow(
                                    color: black.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 10,
                                    offset: Offset(5, 5),
                                  ),
                                ]),
                      child: Text(
                        // DateFormat('dd MMM kk:mm').format(
                        DateFormat('kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(messageChat.timestamp))),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  void onInit() {
    authProvider = AuthProvider();
    chatProvider = ChatProvider(
        firebaseFirestore: FirebaseFirestore.instance,
        firebaseStorage: FirebaseStorage.instance);
    focusNode.addListener(onFocusChange);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
