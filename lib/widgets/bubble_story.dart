import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:soctra/utils/colors.dart';
import 'package:soctra/widgets/text.dart';

class BubbleStory extends StatelessWidget {
  final String image;
  final String nama_alias;
  const BubbleStory({super.key, required this.image, required this.nama_alias});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: swatch
                      .harmonizeWith(Theme.of(context).colorScheme.primary)
                      .withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
              Positioned(
                top: 2,
                bottom: 2,
                right: 2,
                left: 2,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 4,
                bottom: 4,
                right: 4,
                left: 4,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(imageUrl: image),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          CText(
            nama_alias,
            fontSize: 12,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
