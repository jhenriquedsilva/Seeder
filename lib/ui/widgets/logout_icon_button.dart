import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/seed_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/UIUtils.dart';
import '../screens/sign_in_screen.dart';
import 'custom_alert_dialog.dart';

class LogoutIconButton extends StatefulWidget {
  const LogoutIconButton({Key? key}) : super(key: key);

  @override
  State<LogoutIconButton> createState() => _LogoutIconButtonState();
}

class _LogoutIconButtonState extends State<LogoutIconButton> {
  Future<void> verifyNonSynchonizedSeeds() async {
    try {
      final thereAreNonSynchronizedSeeds =
      await Provider.of<SeedProvider>(context, listen: false)
          .areThereAnyNonSynchronized();

      if (thereAreNonSynchronizedSeeds) {
        final isLoggingOut = await getAlertDialogResponse();

        if (isLoggingOut != null && isLoggingOut) {
          logout();
        }
      } else {
        logout();
      }
    } catch (error) {
      UIUtils.showSnackBar(context, error.toString());
    }
  }

  Future<bool?> getAlertDialogResponse() {
    return showDialog<bool>(
      context: context,
      builder: (_) => const CustomAlertDialog(),
    );
  }

  Future<void> logout() async {
    await Provider.of<SeedProvider>(context, listen: false).clear();
    await Provider.of<UserProvider>(context, listen: false).clear();
    Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await verifyNonSynchonizedSeeds();
        },
        icon: const Icon(Icons.logout));
  }
}
