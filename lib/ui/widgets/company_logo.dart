import 'package:flutter/material.dart';

class CompanyLogo extends StatelessWidget {
  const CompanyLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Image.asset(
        'assets/images/aegro-logo.png',
        width: 200,
        height: 200,
        errorBuilder: (context, exception, stackTrace) {
          return const Text(
            'Aegro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.w900,
            ),
          );
        },
      ),
    );
  }
}
