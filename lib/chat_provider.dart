import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'chat.dart';

class ChatProvider extends ChangeNotifier {
  List<String> responses = [];
  List<Chat> requests = [];

  void sendMessage(String message) async {
    final gemini = Gemini.instance;

    gemini
        .text(message)
        .then((value) => print(value?.output))
        .catchError((e) => print(e));
  }

  void sendWithImage(String message, File img) {
    final gemini = Gemini.instance;

    gemini.textAndImage(text: message, image: img)
  }


}
