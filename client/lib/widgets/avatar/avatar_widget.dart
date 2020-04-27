import 'package:cash_flow/resources/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({@required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: url == null
          ? const AssetImage(Images.defaultAvatar)
          : NetworkImage(url),
      radius: 48,
    );
  }
}
