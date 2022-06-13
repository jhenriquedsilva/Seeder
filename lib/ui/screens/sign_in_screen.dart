import 'package:flutter/material.dart';
import 'package:seed/ui/screens/sign_up_screen.dart';
import 'package:seed/ui/widgets/company_logo.dart';
import 'package:seed/ui/widgets/sign_in_form.dart';

import '../widgets/custom_text_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const routeName = '/sign_in';

  void navigateToSignUpScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(SignUpScreen.routeName);
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
              child: Column(
                children: [
                  const CompanyLogo(),
                  const SignInForm(),
                  CustomTextButton(
                    text: 'Ainda não possui uma conta?',
                    navigationHandler: () => navigateToSignUpScreen(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
