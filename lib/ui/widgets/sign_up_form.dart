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

  Future<void> processUserInput() async {
    if (!isInputValid()) {
      return;
    }
    saveInput();
    await signUp();
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

  Future<void> signUp() async {
    try {
      await Provider.of<UserProvider>(context, listen: false).signup(
        _userFullNameTextEditingController.text,
        _userEmailTextEditingController.text,
      );
      navigateToSeedScreen();

      UIUtils.showSnackBar(context, 'Conta criada com sucesso');
    } catch (error) {
      UIUtils.showSnackBar(context, error.toString());
    }
  }

  void setUserEmail(String email) {
    _userEmailTextEditingController.text = email;
  }

  void setUserFullName(String fullName) {
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
                  inputHandler: setUserFullName,
                  validator: validateName,
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
                  inputHandler: setUserEmail,
                  validator: validateEmail,
                ),
              ],
            ),
          ),
          CustomElevatedButton(
            text: 'CRIAR',
            pressHandler: processUserInput,
          )
        ],
      ),
    );
  }
}
