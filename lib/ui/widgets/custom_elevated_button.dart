import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    required this.text,
    required this.pressHandler,
    required this.color,
    required this.width,
  });

  final String text;
  final VoidCallback? pressHandler;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        text,
        style: Theme.of(context).textTheme.button,
      ),
      onPressed: pressHandler != null
          ? () {
              pressHandler!();
            }
          : null,
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        fixedSize: Size(width, 60),
        elevation: 16,
        shape: const StadiumBorder(),
      ),
    );
  }
}
