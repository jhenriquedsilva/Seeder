import 'package:flutter/material.dart';
import 'package:seed/models/seed.dart';
import 'package:seed/ui/widgets/seed_item.dart';

class SeedsList extends StatelessWidget {
  const SeedsList({
    Key? key,
    required this.seeds,
  }) : super(key: key);

  final List<Seed> seeds;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: seeds.length,
      itemBuilder: (context, index) {
        return SeedItem(
          seed: seeds[index],
        );
      },
    );
  }
}
