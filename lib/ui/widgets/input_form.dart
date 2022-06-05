import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class InputForm extends StatefulWidget {
  const InputForm({Key? key}) : super(key: key);

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _userEmail;
  String? _userFullName;

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _login() async {
    await Provider.of<AuthProvider>(context, listen: false)
        .login(_userEmail as String);
  }

  Future<void> _signUp() async {
    await Provider.of<AuthProvider>(context, listen: false).signup(
      _userFullName as String,
      _userEmail as String,
    );

    showSnackBar(context, 'Conta criada com sucesso');
  }

  Future<void> _submitForm(BuildContext context, bool isLogin) async {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }

    _formKey.currentState?.save();

    try {
      if (isLogin) {
        await _login();
      } else {
        await _signUp();
      }
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = Provider.of<AuthProvider>(context).isLogin;

    return Form(
      key: _formKey,
        child: Column(
          children: [
            if (!isLogin)
              Padding(
                padding: const EdgeInsets.all(32),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: 'Informe seu nome completo',
                  ),
                  keyboardType: TextInputType.name,
                  validator: (name) {
                    if (name == null || name.trim().isEmpty) {
                      return 'Informe seu nome completo';
                    }
                    return null;
                  },
                  onSaved: (fullName) {
                    _userFullName = fullName as String;
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Informe seu email',
                ),
                validator: (email) {
                  final regex = RegExp(
                      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
                  if (email == null || !regex.hasMatch(email)) {
                    return 'Email inválido';
                  }
                  return null;
                },
                onSaved: (userEmail) {
                  _userEmail = userEmail as String;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.white),
              child: Text(
                isLogin ? 'ENTRAR' : 'CADASTRAR',
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                await _submitForm(context, isLogin);
              },
            ),
            TextButton(
              child: Text(
                isLogin
                    ? 'Ainda não possui uma conta?'
                    : 'Já possui uma conta?',
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false)
                    .changeAuthMode();
              },
            ),
          ],
        ),
      ),
    );
  }
}
