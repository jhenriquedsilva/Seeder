import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seed/validators/validator.dart';

import '../../providers/user_provider.dart';
import '../../utils/UIUtils.dart';
import '../screens/seeds_screen.dart';
import 'custom_elevated_button.dart';
import 'custom_text_form_field.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> with Validator {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _userEmailTextEditingController = TextEditingController();

  final _userFullNameTextEditingController = TextEditingController();

  Future<void> _processUserInput() async {
    if (!_isInputValid()) {
      return;
    }
    _saveInput();
    await _signUp();
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

  Future<void> _signUp() async {
    try {
      await Provider.of<UserProvider>(context, listen: false).signup(
        _userFullNameTextEditingController.text,
        _userEmailTextEditingController.text,
      );
      _navigateToSeedScreen();

      UIUtils.showSnackBar(context, 'Conta criada com sucesso');
    } catch (error) {
      UIUtils.showSnackBar(context, error.toString());
    }
  }

  void _setUserEmail(String email) {
    _userEmailTextEditingController.text = email;
  }

  void _setUserFullName(String fullName) {
    _userFullNameTextEditingController.text = fullName;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 40,
                ),
                CustomTextFormField(
                  cursorColor: Colors.white,
                  borderColor: Colors.white,
                  onSaveHandler: _setUserFullName,
                  validationCallback: validateName,
                  hintText: 'Informe seu nome completo',
                  hintColor: Colors.white,
                  errorMessage: 'Nome inválido',
                  inputType: TextInputType.name,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
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
          CustomElevatedButton(
            text: 'CRIAR',
            pressHandler: () async {
              await _processUserInput();
            },
          )
        ],
      ),
    );
  }
}
