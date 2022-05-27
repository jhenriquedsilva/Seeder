import 'package:flutter/material.dart';
import '../widgets/input_form.dart';

class SingInSignUpScreen extends StatefulWidget {
  const SingInSignUpScreen({Key? key}) : super(key: key);

  @override
  State<SingInSignUpScreen> createState() => _SingInSignUpScreenState();
}

class _SingInSignUpScreenState extends State<SingInSignUpScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Aegro',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            const InputForm(),
          ],
        ),
      ),
    );
  }
}
