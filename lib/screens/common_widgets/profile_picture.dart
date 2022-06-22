import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class ProfilePicture extends StatelessWidget {
  final String pictureUrl;
  final double pictureSize;
  final double pictureRadius;

  const ProfilePicture({
    Key? key,
    required this.pictureUrl,
    required this.pictureSize,
    required this.pictureRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: CachedNetworkImage(
        imageUrl: pictureUrl,
        width: pictureSize,
        height: pictureSize,
        memCacheHeight: pictureSize.toInt(),
        memCacheWidth: pictureSize.toInt(),
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(pictureRadius),
    );
  }
}
