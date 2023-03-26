import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:soctra/utils/colors.dart';
import 'package:soctra/utils/env.dart';

class FullPhotoPage extends StatelessWidget {
  final String url;

  FullPhotoPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        centerTitle: true,
      ),
      body: InteractiveViewer(
        panEnabled: true,
        minScale: 1,
        maxScale: 4,
        child: Center(
          child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.fitWidth,
              placeholder: (context, err) {
                return Container(
                    decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                          color:
                              Theme.of(context).colorScheme.primaryContainer),
                    ));
              }),
        ),
      ),
    );
  }
}
