import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/seed.dart';

class SeedItem extends StatelessWidget {
  const SeedItem({Key? key, required this.seed}) : super(key: key);

  final Seed seed;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
            SizedBox(
              width: screenSize.width * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    seed.name,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    seed.manufacturer,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: screenSize.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Fabricação: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(seed.manufacturedAt),
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Validade: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(seed.expiresIn),
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Registrada: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip,
                      ),
                      Text(DateFormat('dd/MM/yyyy').format(seed.createdAt),
                          overflow: TextOverflow.clip)
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              width: screenSize.width * 0.05,
              child: Icon(
                Icons.sync,
                color: seed.synchronized == 1 ? Colors.green : Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
