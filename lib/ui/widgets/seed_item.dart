import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/seed.dart';

class SeedItem extends StatelessWidget {
  const SeedItem({Key? key, required this.seed}) : super(key: key);

  final Seed seed;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      elevation: 8,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 140,
                  child: Text(
                    seed.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: Text(
                    seed.manufacturer,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Fabricado em: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(DateFormat('dd/MM/yyyy')
                        .format(seed.manufacturedAt))
                  ],
                ),
                Row(
                  children: [
                    const Text('Válida até: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(DateFormat('dd/MM/yyyy').format(seed.expiresIn))
                  ],
                ),
                Row(
                  children: [
                    const Text('Registrada em: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(DateFormat('dd/MM/yyyy').format(seed.createdAt))
                  ],
                )
              ],
            ),
            Icon(
              Icons.sync,
              color: seed.synchronized == 1 ? Colors.green : Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
