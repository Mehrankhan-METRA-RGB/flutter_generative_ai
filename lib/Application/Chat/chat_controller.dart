import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/Data/data.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatController {
  late GenerativeModel model;
  late ChatSession chat;
  final FocusNode textFieldFocus = FocusNode(debugLabel: 'TextField');

  ValueNotifier<bool> sendLoading = ValueNotifier(false);
  ValueNotifier<bool> screenLoading = ValueNotifier(true);
  ScrollController scrollController = ScrollController();
  TextEditingController textController = TextEditingController();
  StreamController<List<Content>> chatsList =
      StreamController<List<Content>>.broadcast();
  List<Content> tempChat = [];
  void init() {
    model = GenerativeModel(
      model: 'gemini-1.5-flash',
      // model: 'gemini-pro',
      apiKey: apiKey,
    );
    chat = model.startChat();
    tempChat.addAll(chat.history);
    chatsList.add(tempChat);
    // chatsList
  }

  void _add(String res) {
    var content = Content.text(res);
    print(content.parts);
    print('*' * 80);
    tempChat.insert(tempChat.isNotEmpty ? tempChat.length - 1 : 0, content);
    chatsList.add(tempChat);
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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  StreamController<GenerateContentResponse> resStreams =
      StreamController<GenerateContentResponse>.broadcast();
  Future<void> sendStreamMultiPart(
      {required String message, File? file}) async {
    if (file != null) {
      Future<DataPart> fileToPart() async {
        return DataPart(
            'image/${file.path.split('.').last}', await file.readAsBytes());
      }

      final image = await fileToPart();

      var responses =
          chat.sendMessageStream(Content.multi([TextPart(message), image]));

      await for (final response in responses) {
        resStreams.add(response);
        print(response.text);
        print('+-+-+-' * 80);
      }
      return;
    }

    var responses = chat.sendMessageStream(Content.text(message));

    await for (final response in responses) {
      resStreams.add(response);
      print(response.text);
      print('+-+-+-' * 80);
    }
  }
}
