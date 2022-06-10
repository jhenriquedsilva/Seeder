import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Sementes não sincronizadas',
        style: TextStyle(color: Colors.black, fontSize: 24),
      ),
      content: const Text(
          'Se você sair agora, perderá as sementes não sincronizadas'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: Colors.green),
            )),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Sincronizar',
                style: TextStyle(color: Colors.green)))
      ],
    );
  }
}
