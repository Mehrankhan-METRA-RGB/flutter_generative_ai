import 'package:flutter/material.dart';
import 'package:flutter_gemini/Application/Chat/chat_controller.dart';
import 'package:flutter_gemini/Presentation/Common/TextFields/chat_text_field.dart';
import 'package:flutter_gemini/Presentation/Widgets/Chat/stream_list.dart';

ChatController controller = ChatController();

class ChatScreen extends StatefulWidget {
  const ChatScreen({required this.apiKey, super.key, required this.title});

  final String apiKey;
  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // late final GenerativeModel _model;
  // late final ChatSession _chat;
  // final ScrollController _scrollController = ScrollController();
  // final TextEditingController _textController = TextEditingController();
  // final FocusNode _textFieldFocus = FocusNode(debugLabel: 'TextField');
  // bool _loading = false;

  @override
  void initState() {
    super.initState();
    controller.init();
    // _model = GenerativeModel(
    //   model: 'gemini-pro',
    //   apiKey: widget.apiKey,
    // );
    // _chat = _model.startChat();
  }

  // void _scrollDown() {
  //   WidgetsBinding.instance.addPostFrameCallback(
  //     (_) => _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: const Duration(
  //         milliseconds: 750,
  //       ),
  //       curve: Curves.easeOutCirc,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final history = controller.chat.history.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: ChatListStream(),
              // StreamBuilder<List<Content>>(
              //     stream: controller.chatsList.stream,
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData) {
              //         return ListView.builder(
              //           controller: controller.scrollController,
              //           itemBuilder: (context, idx) {
              //             final content = snapshot.data![idx];
              //             final text = content.
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
              //           itemCount: history.length,
              //         );
              //       }
              //
              //       return Center(child: CircularProgressIndicator());
              //     }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ChatTextField(
                        focusNode: controller.textFieldFocus,
                        controller: controller.textController,
                        suffixButton: ValueListenableBuilder(
                            valueListenable: controller.sendLoading,
                            builder: (context, loading, child) {
                              if (!loading) {
                                return IconButton(
                                  onPressed: () =>
                                      controller.sendStreamMultiPart(
                                    message: controller.textController.text,
                                  ),
                                  // send(controller.textController.text),
                                  icon: Icon(
                                    Icons.send,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                );
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                        onSubmit: send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void send(String value) {
    if (value != '') {
      controller.send(value,
          onError: (e) => _showError(e),
          onSuccess: (a) => a != null ? setState(() => a) : null);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please something in the field')));
    }
  }

  void _showError(String? message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: Text(message ?? ''),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}
