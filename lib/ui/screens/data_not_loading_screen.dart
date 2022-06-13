import 'package:flutter/material.dart';
import 'package:seed/ui/widgets/company_logo.dart';
import 'package:seed/ui/widgets/custom_elevated_button.dart';

class DataNotLoadingScreen extends StatelessWidget {
  const DataNotLoadingScreen({
    required this.message,
    required this.pressHandler,
  });

  final VoidCallback pressHandler;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CompanyLogo(),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                CustomElevatedButton(
                  text: 'Recarregar',
                  pressHandler: pressHandler,
                  width: MediaQuery.of(context).size.width * 0.7,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
