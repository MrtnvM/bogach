import 'package:cash_flow/resources/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    @required this.url,
    this.size = 40,
    this.borderWidth = 2,
  }) : avatarSize = size - borderWidth;

  final String url;
  final double size;
  final double borderWidth;
  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        border: Border.all(
          width: borderWidth,
          color: Colors.white,
        ),
      ),
      width: size,
      height: size,
      child: CircleAvatar(
        backgroundImage: url == null
            ? const AssetImage(Images.defaultAvatar)
            : NetworkImage(url),
        backgroundColor: Colors.transparent,
        radius: avatarSize,
      ),
    );
  }
}
