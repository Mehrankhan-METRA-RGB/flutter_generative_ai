import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/Data/data.dart';
import 'package:flutter_gemini/Domain/Chat/chat_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatController {
  static const CHAT_LIST = "CHAT_LIST";
  static const CONVERSATION_BOX = "CONVERSATION_BOX";
  late GenerativeModel model;
  late ChatSession chat;
  final FocusNode textFieldFocus = FocusNode(debugLabel: 'TextFormField');

  ValueNotifier<bool> sendLoading = ValueNotifier(false);
  ValueNotifier<bool> screenLoading = ValueNotifier(true);
  ScrollController scrollController = ScrollController();
  TextEditingController textController = TextEditingController();
  StreamController<List<Map<String, dynamic>>> chatStream =
      StreamController.broadcast();
  List<Map<String, dynamic>> tempChat = [];
  List<ChatModel> newTempChat = [];
  StreamController<List<ChatModel>> newChatStream =
      StreamController.broadcast();
  late Box<ChatModel> chatBox;
  void init() async {
    model = GenerativeModel(
      model: 'gemini-1.5-flash',
      // model: 'gemini-pro',
      apiKey: apiKey,
    );
    chat = model.startChat();
    int i = 0;
    tempChat.addAll(chat.history.map((e) {
      var a = {'index': i, 'content': e};
      i++;
      return a;
    }));
    chatStream.add(tempChat);
    await Hive.initFlutter('MrAI');
    chatBox = await Hive.openBox(CHAT_LIST);
    // chatsList.value.addAll(chat.history);
    // chatsList.value = chatsList.value;
    // chatsList
  }

  ValueListenable<Box<ChatModel>> chatBoxData() =>
      Hive.box<ChatModel>(CHAT_LIST).listenable();

  void _add(ChatModel res) {
    Hive.box<ChatModel>(CHAT_LIST).add(res);

    // Hive.box<ChatModel>(CHAT_LIST).putAt(index, value);
  }

  test() {
    chat.history.toList().map((e) {
      // DataPart,FilePart
      e.parts.whereType<TextPart>().map<String>((e) => e.text).join('');
      // e.parts.map((e) => e.toString()).join('');
      // e.parts
      //     .whereType<>()
      //     .map<String>((e) => e.text)
      //     .join('');
    });
  }

  Future<void> send(String message,
      {void Function(String?)? onError,
      void Function(String?)? onSuccess}) async {
    sendLoading.value = true;

    try {
      final response = await chat.sendMessage(
        Content.text(message),
      );
      final text = response.text;

      if (text == null) {
        onError?.call('Empty response.');
        return;
      } else {
        sendLoading.value = false;
        scrollDown();
        onSuccess?.call(text);
      }
    } catch (e) {
      onError?.call(e.toString());

      sendLoading.value = false;
    } finally {
      textController.clear();

      sendLoading.value = false;

      textFieldFocus.requestFocus();
    }
  }

  void scrollDown() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 1,
        ),
        curve: Curves.easeOutCirc,
      );
    }
  }

  Future<void> sendStreamMultiPart(
      {required String message, File? file}) async {
    Content? content;
    List<Part> parts = [];
    String? role;
    // if (file != null) {
    //   Future<DataPart> fileToPart() async {
    //     return DataPart(
    //         'image/${file.path.split('.').last}', await file.readAsBytes());
    //   }
    //
    //   final image = await fileToPart();
    //
    //   var responses =
    //       chat.sendMessageStream(Content.multi([TextPart(message), image]));
    //
    //   await for (final response in responses) {
    //     resStreams.add(response);
    //     print(response.text);
    //     print('+-+-+-' * 80);
    //   }
    //   return;
    // }

    var responses = chat.sendMessageStream(Content.text(message));

    tempChat.add({
      'index': tempChat.isNotEmpty ? tempChat.last['index'] + 1 : 0,
      'content': Content.text(message)
    });
    chatStream.sink.add(tempChat);
    textController.clear();
    int lastIndex = tempChat.isEmpty ? 0 : tempChat.last['index'] + 1;
    try {
      await for (final response in responses) {
        // resStreams.add(response);
        print(parts);
        role ??= response.candidates.first.content.role;
        if (parts.isEmpty) {
          parts = response.candidates.first.content.parts;
          print(parts);
        } else {
          parts.addAll(response.candidates.first.content.parts);
        }
        content = Content.model(parts);
        if (tempChat.length > lastIndex) {
          tempChat.removeAt(lastIndex);
        }
        tempChat.insert(lastIndex, {'index': lastIndex, 'content': content});
        chatStream.sink.add(tempChat);
        scrollDown();
      }
    } catch (e) {
      rethrow;
    }
  }
}
