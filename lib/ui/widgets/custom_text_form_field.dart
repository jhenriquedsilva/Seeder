import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    required this.cursorColor,
    required this.borderColor,
    required this.onSaveHandler,
    required this.validationCallback,
    required this.errorMessage,
    required this.hintText,
    required this.hintColor,
    required this.inputType,
  });

  final Color cursorColor;
  final Color borderColor;
  final void Function(String) onSaveHandler;
  final String? Function(String?, String) validationCallback;
  final String errorMessage;
  final String hintText;
  final Color hintColor;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: cursorColor,
      style: TextStyle(color: cursorColor, fontSize: 16,),
      textAlign: TextAlign.center,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor, fontSize: 16),
        enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: borderColor, width: 2.0)),
        errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.red, width: 2.0)),
      ),
      validator: (text) {
        return validationCallback(text, errorMessage);
      },
      onSaved: (userEmail) {
        onSaveHandler(userEmail as String);
      },
    );
  }
}
