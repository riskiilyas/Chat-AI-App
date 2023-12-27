import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'chat.dart';

class ChatProvider extends ChangeNotifier {
  List<Chat> chats = [];
  bool isLoading = false;
  bool isError = false;

  void _finish() {
    isLoading = false;
    notifyListeners();
  }

  void sendMessage(String message) async {
    final gemini = Gemini.instance;
    chats.add(Chat(msg: message, isRequest: true));
    isLoading = true;
    notifyListeners();

    gemini.text(message).then((value) {
      chats.add(Chat(msg: value!.output.toString(), isRequest: false));
      _finish();
    }).catchError((e) {
      isError = true;
      print(e);
      _finish();
    });
  }

// void sendWithImage(String message, File img) {
//   final gemini = Gemini.instance;
//
//   gemini.textAndImage(text: message, image: img)
// }
}
