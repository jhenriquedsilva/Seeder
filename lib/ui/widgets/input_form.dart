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
          style: const TextStyle(color: Colors.white),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40,
                  ),
                  TextFormField(
                    cursorColor: Colors.white,
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Informe seu nome completo',
                      hintStyle: Theme.of(context).textTheme.labelMedium,
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0)),
                      errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide:
                              BorderSide(color: Colors.red, width: 2.0)),
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
                  )
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(
                  Icons.email,
                  color: Colors.white,
                  size: 40,
                ),
                TextFormField(
                  cursorColor: Colors.white,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Informe seu email',
                    hintStyle: Theme.of(context).textTheme.labelMedium,
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Colors.white, width: 2.0)),
                    errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.red)),
                    focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.red, width: 2.0)),
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
                )
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
            child: Text(
              isLogin ? 'ENTRAR' : 'CADASTRAR',
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: () async {
              await _submitForm(context, isLogin);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              padding: const EdgeInsets.all(16),
              fixedSize: Size(MediaQuery.of(context).size.width * 0.7, 60),
              elevation: 16,
              shadowColor: Colors.green,
              shape: const StadiumBorder(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextButton(
              child: Text(
                  isLogin
                      ? 'Ainda não possui uma conta?'
                      : 'Já possui uma conta?',
                  style: Theme.of(context).textTheme.button),
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false)
                    .changeAuthMode();
              },
            ),
          ),
        ],
      ),
    );
  }
}
