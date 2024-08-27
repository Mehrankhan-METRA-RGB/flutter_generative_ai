import 'package:flutter/material.dart';
import 'package:flutter_gemini/Presentation/Common/TextFields/chat_text_field.dart';
import 'package:flutter_gemini/Presentation/Controllers/Chat/chat_controller.dart';
import 'package:flutter_gemini/Presentation/Widgets/Chat/stream_list.dart';

ChatController controller = ChatController();

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.title});

  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: ChatListStream(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 4,
                left: 15,
                right: 15,
                bottom: 8,
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
                                  onPressed: () => send(
                                    controller.textController.text,
                                  ),
                                  // send(controller.textController.text),
                                  icon: Icon(
                                    Icons.send,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
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
      controller
          .sendStreamMultiPart(
        message: value,
      )
          .catchError((e) {
        _showError(e.toString());
      });
      // controller.send(value,
      //     onError: (e) => _showError(e),
      //     onSuccess: (a) => a != null ? setState(() => a) : null);
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

  @override
  void dispose() {
    super.dispose();
    controller.chatStream.close();
  }
}
