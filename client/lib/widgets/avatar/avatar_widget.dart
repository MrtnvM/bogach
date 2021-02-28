import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    @required this.url,
    this.size = 40,
    this.borderWidth = 2,
    this.borderColor = Colors.white,
  }) : avatarSize = size - borderWidth;

  final String url;
  final double size;
  final double borderWidth;
  final Color borderColor;
  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        border: Border.all(
          width: borderWidth,
          color: borderColor,
        ),
      ),
      width: size,
      height: size,
      child: CircleAvatar(
        backgroundImage: url == null
            ? const AssetImage(Images.defaultAvatar)
            : CachedNetworkImageProvider(url),
        backgroundColor: Colors.transparent,
        radius: avatarSize,
      ),
    );
  }
}
