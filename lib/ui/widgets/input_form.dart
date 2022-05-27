import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/authentication_provider.dart';
import '../../repository/authentication_repository.dart';
import '../screens/seed_screen.dart';

class InputForm extends StatefulWidget {
  const InputForm({Key? key}) : super(key: key);

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _userEmail;
  String? _userFullName;

  Future<void> _saveUserIdWithinSharedPreference(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', id);
  }

  Future<void> _login() async {
    final user =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .login(_userEmail as String);

    // TODO Test if the replacement is working fine
    if (user != null) {
      await _saveUserIdWithinSharedPreference(user.id);
      Navigator.of(context)
      .pushReplacement(
      MaterialPageRoute(builder: (_) => SeedScreen(user.id)));
    }
  }

  Future<void> _signUp() async {
    final userId = await Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    ).signup(
      _userFullName as String,
      _userEmail as String,
    );

    if (userId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso'),
        ),
      );
      Provider.of<AuthenticationProvider>(context, listen: false)
          .changeAuthMode();
    }
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

    } on Exception catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
    // TODO
    // 500
    // time out
    // 503
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = Provider.of<AuthenticationProvider>(context).isLogin;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
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
                Provider.of<AuthenticationProvider>(context, listen: false)
                    .changeAuthMode();
              },
            ),
          ],
        ),
      ),
    );
  }
}
