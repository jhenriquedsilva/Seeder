import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    required this.text,
    required this.pressHandler,
  });

  final String text;
  final VoidCallback pressHandler;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        text,
        style: Theme.of(context).textTheme.button,
      ),
      onPressed: () {
        pressHandler();
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        fixedSize: Size(MediaQuery.of(context).size.width * 0.7, 60),
        elevation: 16,
        shadowColor: Colors.green,
        shape: const StadiumBorder(),
      ),
    );
  }
}
