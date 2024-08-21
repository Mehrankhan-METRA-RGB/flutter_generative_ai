import 'package:flutter/material.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField(
      {super.key,
      this.suffixButton,
      this.onSubmit,
      this.controller,
      this.focusNode});
  final Widget? suffixButton;
  final void Function(String)? onSubmit;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
        suffixIcon: suffixButton,
        contentPadding: const EdgeInsets.all(15),
        hintText: 'Enter a prompt...',
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            color: theme.colorScheme.secondary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(14),
          ),
          borderSide: BorderSide(
            color: theme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
