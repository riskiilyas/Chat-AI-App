import 'package:chat_ai/chat_provider.dart';
import 'package:chat_ai/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatScreen> {
  var name = "";
  TextEditingController controller = TextEditingController();
  List<Message> msg = [];
  final _controller = ScrollController();
  bool isBottom = false;

  void init() async {
    final username = context.read<PrefNotifier>().username;
    final avatarId = context.read<PrefNotifier>().avatarId;
    context.watch<ThemeNotifier>();
    context.watch<ChatNotifier>().init(username, avatarId);
    msg = context.read<ChatNotifier>().chats;
    final status = context.read<ChatNotifier>().status;

    if (status == EventStatus.JOINED) {
      context.showSnackbar("Joined the server!");
    } else if (status == EventStatus.SENT_CHAT) {
      context.showSnackbar("Joined the server!");
    }
  }

  void checkForAutoScroll() {
    if (!_controller.hasClients) return;
    if (_controller.position.atEdge) {
      isBottom = _controller.position.pixels != 0;
      if (isBottom) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _controller.jumpTo(_controller.position.maxScrollExtent);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    checkForAutoScroll();
    final notifier = context.read<ChatProvider>();
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                        controller: _controller,
                        itemCount: msg.length,
                        itemBuilder: (context, index) {
                          final username = context.prefNotifier.username;
                          if (msg[index] is Chat) {
                            final _ = msg[index] as Chat;
                            if (_.username == username) {
                              return MeChatWidget(
                                avatar: _.avatarId,
                                username: _.username,
                                msg: _.message,
                                time: "",
                              );
                            }
                            return UserChatWidget(
                                avatar: _.avatarId,
                                username: _.username,
                                msg: _.message,
                                time: "",
                                onUserClicked: (_) {});
                          } else if (msg[index] is OnlineUser) {
                            final _ = msg[index] as OnlineUser;
                            return UserJoinedWidget(user: _.username);
                          } else if (msg[index] is Sticker) {
                            final _ = msg[index] as Sticker;
                            if (_.username == username) {
                              return MeStickerItem(username: _.username,
                                  avatarId: _.avatarId, stickerId: _.stickerId);
                            } else {
                              return UserStickerItem(username: _.username,
                                  avatarId: _.avatarId, stickerId: _.stickerId);
                            }
                          } else {
                            return const SizedBox();
                          }
                        }),
                    Positioned(
                        bottom: 10,
                        right: 0,
                        child: ArrowDownButton(controller: _controller)),
                  ],
                )),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 5,
                    style: TextStyle(color: Styles.COLOR_TEXT),
                    onChanged: (_) => name = _,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Styles.COLOR_TEXT_BACKGROUND,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(64),
                        borderSide: BorderSide(
                            color: Styles.COLOR_TEXT_BACKGROUND, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(64),
                        borderSide: BorderSide(
                            color: Styles.COLOR_TEXT_BACKGROUND, width: 1.0),
                      ),
                      hintText: 'Tuliskan Pesan Anda....',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                InkWell(
                  onTap: () {
                    Dialogs.showStickerPicker(context).then((value) {
                      if (value != null) {
                        context.read<ChatNotifier>().sendSticker(value);
                      }
                    });
                  },
                  child: Material(
                    elevation: 10,
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Styles.COLOR_MAIN,
                            borderRadius: BorderRadius.circular(64)),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.emoji_emotions,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
                4.widthBox,
                InkWell(
                  onTap: () {
                    controller.clear();
                    context.read<ChatNotifier>().sendMessage(name);
                  },
                  child: Material(
                    elevation: 10,
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    child: Container(
                        decoration: BoxDecoration(
                            color: context.primaryColor,
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
                4.widthBox,
                InkWell(
                  onTap: () {
                    controller.clear();
                    notifier.sendMessage(message);
                  },
                  child: Material(
                    elevation: 10,
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    child: Container(
                        decoration: BoxDecoration(
                            color: context.primaryColor,
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
            ),
          ],
        ),
      ),
    );
  }
}
