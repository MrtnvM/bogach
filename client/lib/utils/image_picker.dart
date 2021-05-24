import 'dart:io';

import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> chooseImage({
  required BuildContext context,
  CropAspectRatio? aspectRatio,
}) async {
  final source = await _showChooseSourceTypeDialog(context);
  if (source == null) {
    return null;
  }

  late ImageSource imageSource;

  switch (source) {
    case ImageSourceType.camera:
      imageSource = ImageSource.camera;
      break;

    case ImageSourceType.gallery:
      imageSource = ImageSource.gallery;
      break;
  }

  try {
    final image = await ImagePicker().getImage(source: imageSource);

    if (image != null) {
      return _cropImage(File(image.path), aspectRatio);
    }
  } catch (e) {
    if (e is PlatformException) {
      switch (e.code) {
        case 'camera_access_denied':
          showDialogGoToAppSettings(context, NoAccessMode.camera);
          break;

        case 'photo_access_denied':
          showDialogGoToAppSettings(context, NoAccessMode.gallery);
          break;
      }
    }
  }

  return null;
}

Future<ImageSourceType?> _showChooseSourceTypeDialog(BuildContext context) {
  return showDialog<ImageSourceType>(
    context: context,
    builder: (context) => SimpleDialog(
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop(ImageSourceType.camera);
          },
          child: ListTile(
            leading: const Icon(Icons.camera_rounded),
            title: Text(Strings.camera),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop(ImageSourceType.gallery);
          },
          child: ListTile(
            leading: const Icon(Icons.photo_library),
            title: Text(Strings.gallery),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Text(
              Strings.cancel,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: ColorRes.mainGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Future<File> _cropImage(File image, CropAspectRatio? aspectRatio) async {
  final croppedFile = await ImageCropper.cropImage(
    sourcePath: image.path,
    aspectRatio: aspectRatio,
    maxWidth: 512,
    maxHeight: 512,
    androidUiSettings: const AndroidUiSettings(toolbarColor: ColorRes.white),
  );

  return Future.value(croppedFile);
}

enum ImageSourceType { gallery, camera }
