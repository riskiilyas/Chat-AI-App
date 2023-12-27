import 'dart:io';

import 'package:chat_ai/extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:badges/badges.dart' as badges;

class PickImageWidget extends StatefulWidget {
  final Function(File) onPicked;
  final Function onRemove;

  const PickImageWidget({Key? key, required this.onPicked, required this.onRemove}) :
super(key:
  key);

  @override
  State<PickImageWidget> createState() => _PickImageWidgetState();
}

class _PickImageWidgetState extends State<PickImageWidget> {
  bool isPicked = false;

  Future<File?> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() async {
          if(isPicked) {
            widget.onRemove();
            isPicked = false;
            return;
          }

          final pickedFile = await pickImage();
          if (pickedFile != null) {
            isPicked = true;
            widget.onPicked(pickedFile);
          }
        });
      },
      child: Material(
        elevation: 10,
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        child: Container(
            decoration: BoxDecoration(
                color: context.primaryColor.scaleRGB(.3),
                borderRadius: BorderRadius.circular(64)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: badges.Badge(
                badgeStyle: const badges.BadgeStyle(badgeColor: Colors.redAccent),
                badgeContent: Icon(
                  (isPicked) ? Icons.clear : Icons.add,
                  size: 10,
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.image,
                  color: Colors.white,
                ),
              ),
            )),
      ),
    );
  }
}
