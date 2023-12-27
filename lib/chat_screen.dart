import 'dart:math';

import 'package:chat_ai/chat_provider.dart';
import 'package:chat_ai/extension.dart';
import 'package:chat_ai/widgets/arrow_down_button.dart';
import 'package:chat_ai/widgets/me_chat_widget.dart';
import 'package:chat_ai/widgets/me_chat_with_image_widget.dart';
import 'package:chat_ai/widgets/chat_actions_widget.dart';
import 'package:chat_ai/widgets/response_chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatScreen> {
  var message = "";
  TextEditingController controller = TextEditingController();
  File? pickedFile;

  // List<Message> msg = [];
  final _controller = ScrollController();
  bool isBottom = false;

  void init() async {}

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

  List<Widget> generateChats(ChatProvider provider) {
    final List<Widget> list = provider.chats.map((_) {
      if (_.isRequest) {
        if (_.img != null) {
          return MeChatWithImageWidget(
              img: _.img!,
              username: 'You',
              msg: _.msg,
              time: DateTime.now().toIso8601String().substring(0, 10));
        }
        return MeChatWidget(
            username: 'You',
            msg: _.msg,
            time: DateTime.now().toIso8601String().substring(0, 10));
      }
      return ResponseChatWidget(
          username: 'Gemini',
          msg: _.msg,
          time: DateTime.now().toIso8601String().substring(0, 10));
    }).toList();

    return [
      ...list,
      provider.isLoading
          ? Center(
              child: SpinKitWave(
              color: context.primaryColor.scaleRGB(1),
            )).withPadding(12.topPadding)
          : const SizedBox()
    ];
  }

  @override
  Widget build(BuildContext context) {
    init();
    checkForAutoScroll();
    final notifier = context.read<ChatProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'assets/gemini.png',
          // height: 200,
        ),
        title: const Text(
          "CHAT AI",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: context.primaryColor.scaleRGB(.3),
      ),
      backgroundColor: context.primaryColor.scaleRGB(.1),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
                child: Stack(
              children: [
                Consumer<ChatProvider>(builder: (context, provider, widget) {
                  final list = generateChats(provider);
                  return ListView.builder(
                      controller: _controller,
                      itemCount: notifier.chats.length + 1,
                      itemBuilder: (context, index) => list[index]);
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
                    style: const TextStyle(color: Colors.white),
                    onChanged: (_) => message = _,
                    decoration: InputDecoration(
                      hintStyle:
                          TextStyle(color: context.primaryColor.scaleRGB(.7)),
                      filled: true,
                      fillColor: context.primaryColor.scaleRGB(.3),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(64),
                        borderSide: BorderSide(
                            color: context.primaryColor.scaleRGB(2),
                            width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(64),
                        borderSide: BorderSide(
                            color: context.primaryColor.scaleRGB(.5),
                            width: 1.0),
                      ),
                      hintText: 'Write your message here....',
                    ),
                  ),
                ),
                8.widthBox,
                ChatActionsWidget(
                  onPicked: (_) {
                    pickedFile = _;
                  },
                  onRemove: () {
                    pickedFile = null;
                  },
                  onSend: () {
                    controller.clear();
                    if (pickedFile == null) {
                      notifier.sendMessage(message);
                    } else {
                      notifier.sendWithImage(message, pickedFile!);
                      pickedFile = null;
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
