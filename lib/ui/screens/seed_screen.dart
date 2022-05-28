import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seed/providers/auth_provider.dart';

enum DropDownMenuAction { logout }

class SeedScreen extends StatelessWidget {
  static const routeName = '/seed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sementes'),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                value: DropDownMenuAction.logout,
                child: Row(
                  children: const [
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Sair')
                  ],
                ),
              )
            ],
            onChanged: (itemId) {
              if (itemId == DropDownMenuAction.logout) {
                Provider.of<AuthProvider>(context, listen: false).logout();
                Provider.of<AuthProvider>(context, listen: false).changeToLoginMode();
              }
            },
          )
        ],
      ),
    );
  }
}
