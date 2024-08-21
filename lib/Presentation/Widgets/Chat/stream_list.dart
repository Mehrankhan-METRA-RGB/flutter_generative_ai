import 'package:flutter/material.dart';
import 'package:flutter_gemini/Presentation/Common/Tile/message_tile.dart';
import 'package:flutter_gemini/Presentation/Widgets/Chat/chat_screen.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatListStream extends StatefulWidget {
  const ChatListStream({super.key});

  @override
  State<ChatListStream> createState() => _ChatListStreamState();
}

class _ChatListStreamState extends State<ChatListStream> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.resStreams.stream.listen((a) {
      print('LISTEN:${a.candidates.first.content.role}');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var history = controller.chat.history;
    return ListView.builder(
      shrinkWrap: true,
      controller: controller.scrollController,
      itemBuilder: (context, idx) {
        var content = history.toList()[idx];
        var text = content.
            // parts.map((e) => e.toString()).join('');
            parts
            .whereType<TextPart>()
            .map<String>((e) => e.text)
            .join('');
        return MessageTile(
          text: text,
          isLastTyping: history.isNotEmpty ? history.length - 1 == idx : false,
          isFromUser: content.role == 'user',
        );
      },
      itemCount: controller.chat.history.length,
    );

    // StreamBuilder<GenerateContentResponse>(
    //     stream: controller.resStreams.stream,
    //     builder: (context, snapshot) {
    //       print('SNAP:${snapshot.data}');
    //       var history = controller.chat.history;
    //       if (snapshot.hasData) {
    //         return ListView.builder(
    //           shrinkWrap: true,
    //           controller: controller.scrollController,
    //           itemBuilder: (context, idx) {
    //             var content = history.toList()[idx];
    //             var text = content.
    //                 // parts.map((e) => e.toString()).join('');
    //                 parts
    //                 .whereType<TextPart>()
    //                 .map<String>((e) => e.text)
    //                 .join('');
    //             return MessageTile(
    //               text: text,
    //               isFromUser: content.role == 'user',
    //             );
    //           },
    //           itemCount: controller.chat.history.length,
    //         );
    //       }
    //
    //       return const Center(child: CircularProgressIndicator());
    //     });
  }
}
