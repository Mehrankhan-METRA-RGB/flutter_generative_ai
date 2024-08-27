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
  }

  List<Map<String, dynamic>> chat = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      // initialData: controller.chat.history.toList(),
      stream: controller.chatStream.stream,
      builder: (
        context,
        snap,
      ) {
        print(snap);
        if (snap.hasData) {
          var contents = snap.data!.toList();
          return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            controller: controller.scrollController,
            itemBuilder: (context, idx) {
              Content content = contents[idx]['content'] as Content;
              var text = content.parts
                  .whereType<TextPart>()
                  .map<String>((e) => e.text)
                  .join('');
              return MessageTile(
                text: text,
                isLastTyping: chat.isNotEmpty ? chat.length - 1 == idx : false,
                isFromUser: content.role == 'user',
              );
            },
            itemCount: contents.length,
          );
        } else if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        } else {
          return const Center(
            child: Text("No Chat Found"),
          );
        }
      },
    );
  }
}
