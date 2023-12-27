import 'dart:io';

import 'package:chat_ai/extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:badges/badges.dart' as badges;

class ChatActionsWidget extends StatefulWidget {
  final Function(File) onPicked;
  final Function onRemove;
  final Function onSend;

  const ChatActionsWidget(
      {Key? key,
      required this.onPicked,
      required this.onRemove,
      required this.onSend})
      : super(key: key);

  @override
  State<ChatActionsWidget> createState() => _ChatActionsWidgetState();
}

class _ChatActionsWidgetState extends State<ChatActionsWidget> {
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
    return Row(
      children: [
        InkWell(
          onTap: () async {
            if (isPicked) {
              widget.onRemove();
              setState(() {
                isPicked = false;
              });
              return;
            }

            final pickedFile = await pickImage();
            if (pickedFile != null) {
              widget.onPicked(pickedFile);
              setState(() {
                isPicked = true;
              });
            }
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
                    badgeStyle:
                        const badges.BadgeStyle(badgeColor: Colors.redAccent),
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
        ),
        4.widthBox,
        InkWell(
          onTap: () {
            widget.onSend();
            setState(() {
              isPicked = false;
            });
          },
          child: Material(
            elevation: 10,
            borderRadius: const BorderRadius.all(Radius.circular(32)),
            child: Container(
                decoration: BoxDecoration(
                    color: context.primaryColor.scaleRGB(.3),
                    borderRadius: BorderRadius.circular(64)),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.message_outlined,
                    color: Colors.white,
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
