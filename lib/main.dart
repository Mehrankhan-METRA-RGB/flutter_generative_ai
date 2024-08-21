import 'package:flutter/material.dart';
import 'package:flutter_gemini/Data/data.dart';
import 'package:flutter_gemini/Presentation/Widgets/Chat/chat_screen.dart';

void main() {
  runApp(const GenerativeAISample());
}

class GenerativeAISample extends StatelessWidget {
  const GenerativeAISample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mr AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color.fromARGB(255, 171, 222, 244),
        ),
        useMaterial3: true,
      ),
      home: const ChatScreen(apiKey: apiKey, title: 'Mr AI'),
    );
  }
}

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//         ),
//         body: const ChatWidget(apiKey: apiKey)
//         // switch (apiKey) {
//         //   final providedKey? => ChatWidget(apiKey: providedKey),
//         //   _ => ApiKeyWidget(onSubmitted: (key) {
//         //       setState(() => apiKey = key);
//         //     }),
//         // },
//         );
//   }
// }

// class ApiKeyWidget extends StatelessWidget {
//   ApiKeyWidget({required this.onSubmitted, super.key});
//
//   final ValueChanged<String> onSubmitted;
//   final TextEditingController _textController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'To use the Gemini API, you\'ll need an API key. '
//               'If you don\'t already have one, '
//               'create a key in Google AI Studio.',
//             ),
//             const SizedBox(height: 8),
//             Link(
//               uri: Uri.https('makersuite.google.com', '/app/apikey'),
//               target: LinkTarget.blank,
//               builder: (context, followLink) => TextButton(
//                 onPressed: followLink,
//                 child: const Text('Get an API Key'),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration:
//                         textFieldDecoration(context, 'Enter your API key'),
//                     controller: _textController,
//                     onSubmitted: (value) {
//                       onSubmitted(value);
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextButton(
//                   onPressed: () {
//                     onSubmitted(_textController.value.text);
//                   },
//                   child: const Text('Submit'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
