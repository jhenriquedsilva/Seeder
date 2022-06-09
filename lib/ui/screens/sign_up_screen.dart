import 'package:flutter/material.dart';
import 'package:seed/ui/screens/sign_in_screen.dart';
import 'package:seed/ui/widgets/sign_up_form.dart';

import '../widgets/company_logo.dart';
import '../widgets/custom_text_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const routeName = 'sign_up';

  void navigateToSignScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
  }

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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const CompanyLogo(),
                    const SignUpForm(),
                    CustomTextButton(
                      text: 'Já possui uma conta?',
                      navigationHandler: () => navigateToSignScreen(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
