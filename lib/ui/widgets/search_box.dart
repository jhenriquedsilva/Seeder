import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/seed_provider.dart';
import '../../utils/UIUtils.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.green)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.green, width: 2.0)),
            hintText: 'Buscar sementes...',
            hintStyle: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Colors.black)),
        onChanged: (query) {
          try {
            Provider.of<SeedProvider>(context, listen: false)
                .searchSeeds(query);
          } catch (error) {
            UIUtils.showSnackBar(context, 'Não foi possível buscar sementes');
          }
        },
      ),
    );
  }
}
