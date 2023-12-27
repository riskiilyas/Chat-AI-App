import 'package:chat_ai/chat_provider.dart';
import 'package:chat_ai/extension.dart';
import 'package:chat_ai/widgets/arrow_down_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatScreen> {
  var message = "";
  TextEditingController controller = TextEditingController();

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
        title: Text(
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
                ListView.builder(
                    controller: _controller,
                    itemCount: notifier.chats.length,
                    itemBuilder: (context, index) {}),
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
                      hintStyle: TextStyle(color: context.primaryColor.scaleRGB(.7)),
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
                const SizedBox(
                  width: 4,
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
                            color: context.primaryColor.scaleRGB(.3),
                            borderRadius: BorderRadius.circular(64)),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.image,
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
            ),
          ],
        ),
      ),
    );
  }
}
