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
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: Image.network(
                      'https://play-lh.googleusercontent.com/'
                          '3GIcAg0p2xsj-BuSEw2oima33RDarawUoJeWRWb'
                          '-AIuq0Zxb5XwvckqRpONPSGodtUjh',
                      width: 200,
                      height: 200,
                      errorBuilder: (context, exception, stackTrace) {
                        return Text(
                          'Aegro',
                          style: Theme.of(context).textTheme.headline6,
                        );
                      },
                    ),
                  ),
                  const InputForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
