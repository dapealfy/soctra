import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:soctra/utils/colors.dart';
import 'package:soctra/widgets/text.dart';

import '../controllers/story_controller.dart';

class StoryView extends GetView<StoryController> {
  const StoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> dataStory = [];
    for (var i = 0; i < 10; i++) {
      dataStory.add(Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),
      ));
    }
    return Scaffold(
      backgroundColor: black,
      body: GetBuilder<StoryController>(
          init: StoryController(),
          builder: (c) {
            return WillPopScope(
              onWillPop: c.onBackPress,
              child: Dismissible(
                direction: DismissDirection.vertical,
                key: const Key('key'),
                onDismissed: (_) => Get.back(),
                child: SafeArea(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 80,
                        left: 0,
                        right: 0,
                        child: Image.network(
                          'https://images.unsplash.com/photo-1673537074513-e66435b69012?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return const Material(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Icon(Icons.error),
                            );
                          },
                        ),
                      ),
                      c.focusNode.hasFocus
                          ? Positioned(
                              top: 0,
                              bottom: 80,
                              left: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                child: Container(
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            )
                          : Container(),
                      Positioned(
                        top: 12,
                        left: 12,
                        right: 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                              color: black,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
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
                                              'Daffa',
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        CText(
                                          'Balikpapan',
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      height: 3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: dataStory,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 12,
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 55,
                                child: TextField(
                                  focusNode: c.focusNode,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    fillColor: black,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: black, width: 0.0),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: black, width: 0.0),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    hintText: 'Ketik Pesan',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            c.focusNode.hasFocus
                                ? SizedBox(
                                    width: 60,
                                    child: FloatingActionButton(
                                      shape: CircleBorder(),
                                      onPressed: () {},
                                      child: Icon(Icons.send),
                                    ),
                                  )
                                : SizedBox(
                                    width: 60,
                                    child: IconButton(
                                      icon: Icon(Icons.share),
                                      onPressed: () {},
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
