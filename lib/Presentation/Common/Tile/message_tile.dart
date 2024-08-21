import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.text,
    required this.isFromUser,
    required this.isLastTyping,
  });

  final String text;
  final bool isFromUser;
  final bool isLastTyping;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            decoration: BoxDecoration(
              color: isFromUser
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            margin: const EdgeInsets.only(bottom: 8),
            child: MarkdownBody(
              data: text,
              imageBuilder: (uri, a, b) => Image.network(uri.path),
            ),
          ),
        ),
      ],
    );
  }
}
