import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.url,
    this.size = 40,
    this.borderWidth = 2,
    this.borderColor = Colors.white,
    this.pickedAvatar,
  }) : avatarSize = size - borderWidth;

  final String? url;
  final double size;
  final double borderWidth;
  final Color? borderColor;
  final double avatarSize;
  final FileImage? pickedAvatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        border: Border.all(
          width: borderWidth,
          color: borderColor!,
        ),
      ),
      width: size,
      height: size,
      child: CircleAvatar(
        backgroundImage: _pickSource(),
        backgroundColor: Colors.transparent,
        radius: avatarSize,
      ),
    );
  }

  ImageProvider? _pickSource() {
    if (pickedAvatar != null) {
      return pickedAvatar;
    }
    if (url != null) {
      return CachedNetworkImageProvider(url!);
    }
    return const AssetImage(Images.defaultAvatar);
  }
}
