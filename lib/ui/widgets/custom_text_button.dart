import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    required this.text,
    required this.navigationHandler,
  });

  final String text;
  final void Function() navigationHandler;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: Text(text, style: Theme.of(context).textTheme.button),
        onPressed: () {
          navigationHandler();
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      );
  }
}
