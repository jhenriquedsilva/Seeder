import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seed/ui/screens/data_not_loading_screen.dart';
import 'package:seed/ui/widgets/loading_indicator.dart';
import 'package:seed/ui/widgets/seeds_list.dart';
import 'package:seed/ui/widgets/warning.dart';

import '../../providers/seed_provider.dart';

class SeedsDashboard extends StatefulWidget {
  const SeedsDashboard({Key? key}) : super(key: key);

  @override
  State<SeedsDashboard> createState() => _SeedsDashboardState();
}

class _SeedsDashboardState extends State<SeedsDashboard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<SeedProvider>(context, listen: false).cacheSeeds(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        } else if (snapshot.hasError) {
          return DataNotLoadingScreen(
            message: snapshot.error.toString(),
            pressHandler: () {
              setState(() {});
            },
          );
        } else {
          return Expanded(
            child: Consumer<SeedProvider>(
              builder: (context, seedProvider, __) {
                if (seedProvider.allSeeds.isEmpty) {
                  return const Warning();
                } else {
                  return SeedsList(
                    seeds: seedProvider.allSeeds,
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}
