import 'package:flutter/material.dart';

class UserChatWidget extends StatelessWidget {
  final int avatar;
  final String username;
  final String msg;
  final String time;
  final Function(String) onUserClicked;

  const UserChatWidget(
      {Key? key,
      required this.avatar,
      required this.username,
      required this.msg,
      required this.time,
      required this.onUserClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              fit: StackFit.passthrough,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            time,
                            style: const TextStyle(color: Colors.white38),
                          ),
                          Text(
                            username,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white60),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
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
                  left: 0,
                  child: CircleAvatar(
                      radius: 12,
                      foregroundImage:
                          Image.asset("assets/avatars/$avatar.png").image),
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
