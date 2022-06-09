import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seed/validators/validator.dart';

import '../../providers/user_provider.dart';
import '../../utils/UIUtils.dart';
import '../screens/seeds_screen.dart';
import 'custom_elevated_button.dart';
import 'custom_text_form_field.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> with Validator {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _userEmail;

  Future<void> _processUserInput() async {
    if (!isInputValid()) {
      return;
    }
    saveInput();
    await signIn();
  }

  bool isInputValid() {
    final isValid = _formKey.currentState?.validate();
    return isValid != null && isValid;
  }

  void saveInput() {
    _formKey.currentState?.save();
  }

  void navigateToSeedScreen() {
    Navigator.of(context).pushReplacementNamed(SeedsScreen.routeName);
  }

  Future<void> signIn() async {
    try {
      await Provider.of<UserProvider>(context, listen: false).signIn(
        _userEmail as String,
      );
      navigateToSeedScreen();

    } catch (error) {
      UIUtils.showSnackBar(context, error.toString());
    }
  }

  void setUserEmail(String email) {
    _userEmail = email;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(
                  Icons.email,
                  color: Colors.white,
                  size: 40,
                ),
                CustomTextFormField(
                  inputHandler: setUserEmail,
                  validator: validateEmail,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          CustomElevatedButton(
            text: 'ENTRAR',
            pressHandler: _processUserInput,
          ),
        ],
      ),
    );
  }
}