import 'package:chat_ai/extension.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class MeChatWithImageWidget extends StatelessWidget {
  final String username;
  final String msg;
  final String time;
  final File img;

  const MeChatWithImageWidget(
      {Key? key,
      required this.img,
      required this.username,
      required this.msg,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Wrap(
          alignment: WrapAlignment.end,
          children: [
            Stack(
              clipBehavior: Clip.none,
              fit: StackFit.passthrough,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: context.primaryColor.scaleRGB(.15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Wrap(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            time,
                            style: const TextStyle(color: Colors.white38),
                          ),
                          12.widthBox,
                          Text(
                            username,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white60),
                          ),
                        ],
                      ),
                      8.heightBox,
                      Image.file(img, height: 100,),
                      8.heightBox,
                      Text(
                        msg,
                        maxLines: 10,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 12,
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: -8,
                  right: 0,
                  child: CircleAvatar(
                      radius: 12,
                      foregroundImage:
                          Image.asset("assets/user_chat.png").image),
                )
              ],
            ),
            const SizedBox(
              width: double.infinity,
            )
          ],
        ),
        const SizedBox(
          height: 12,
        )
      ],
    );
  }
}
