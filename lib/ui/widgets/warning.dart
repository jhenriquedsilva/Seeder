import 'package:flutter/material.dart';

class Warning extends StatelessWidget {
  const Warning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Não há sementes',
        style: Theme.of(context)
            .textTheme
            .labelMedium!
            .copyWith(color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}
