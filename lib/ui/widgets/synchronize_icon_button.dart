import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../exceptions/db_cannot_insert_data_exception.dart';
import '../../exceptions/db_does_not_load_data_exception.dart';
import '../../providers/seed_provider.dart';
import '../../utils/UIUtils.dart';

class SynchronizeIconButton extends StatefulWidget {
  const SynchronizeIconButton({Key? key, required this.errorHandler}) : super(key: key);

  final VoidCallback errorHandler;

  @override
  State<SynchronizeIconButton> createState() => _SynchronizeIconButtonState();
}

class _SynchronizeIconButtonState extends State<SynchronizeIconButton> {
  Future<void> synchronize() async {
    try {
      await Provider.of<SeedProvider>(context, listen: false)
          .synchronize();
      UIUtils.showSnackBar(context, 'Sementes sincronizadas');
    } on DbCannotInsertDataException {
      widget.errorHandler;
    } on DbDoesNotLoadDataException {
      widget.errorHandler;
    } catch (error) {
      UIUtils.showSnackBar(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.sync),
      onPressed: () async {
        await synchronize();
      },
    );
  }
}
