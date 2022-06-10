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
    if (!_isInputValid()) {
      return;
    }
    _saveInput();
    await _signIn();
  }

  bool _isInputValid() {
    final isValid = _formKey.currentState?.validate();
    return isValid != null && isValid;
  }

  void _saveInput() {
    _formKey.currentState?.save();
  }

  void _navigateToSeedScreen() {
    Navigator.of(context).pushReplacementNamed(SeedsScreen.routeName);
  }

  Future<void> _signIn() async {
    try {
      await Provider.of<UserProvider>(context, listen: false).signIn(
        _userEmail as String,
      );
      _navigateToSeedScreen();

    } catch (error) {
      UIUtils.showSnackBar(context, error.toString());
    }
  }

  void _setUserEmail(String email) {
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
                  cursorColor: Colors.white,
                  borderColor: Colors.white,
                  onSaveHandler: _setUserEmail,
                  validationCallback: validateEmail,
                  hintText: 'Informe seu email',
                  hintColor: Colors.white,
                  errorMessage: 'Email inválido',
                  inputType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          CustomElevatedButton(
            text: 'ENTRAR',
            pressHandler: () async {
              await _processUserInput();
            }
          ),
        ],
      ),
    );
  }
}
