import 'dart:io';

import 'package:cash_flow/utils/image_picker.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:cash_flow/widgets/buttons/raised_icon_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EditableUserAvatar extends HookWidget {
  const EditableUserAvatar({
    @required this.url,
    this.onChanged,
    this.size = 40,
  });

  final String url;
  final void Function(File imageFile) onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final pickedImage = useState<File>(null);

    useMemoized(() {
      pickedImage.value = null;
    }, [url]);

    Future<void> pickImage() async {
      final newPickedImage =
          await chooseImage(context: context) ?? pickedImage.value;
      pickedImage.value = newPickedImage;
      onChanged?.call(pickedImage.value);
    }

    return Center(
      child: Stack(
        children: [
          RaisedButton(
            onPressed: pickImage,
            shape: const CircleBorder(),
            child: UserAvatar(
              url: url,
              size: size,
              borderWidth: 0,
              pickedAvatar: pickedImage.value != null
                  ? FileImage(pickedImage.value)
                  : null,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: RaisedIconButton(
              onPressed: pickImage,
              icon: Icons.edit,
            ),
          ),
        ],
      ),
    );
  }
}
