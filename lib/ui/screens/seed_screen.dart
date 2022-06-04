import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seed/providers/auth_provider.dart';
import 'package:seed/providers/seed_provider.dart';
import 'package:seed/ui/screens/add_new_seed_screen.dart';

class SeedsScreen extends StatelessWidget {
  static const routeName = '/seed';

  const SeedsScreen({Key? key}) : super(key: key);

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sementes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              try {

                await Provider.of<SeedProvider>(context, listen: false)
                    .synchronize();
                showSnackBar(context, 'Sementes sincronizadas com sucesso');
              } catch (error) {
                showSnackBar(context, error.toString());
              }

            },
          ),
          IconButton(
              onPressed: () async {
                final areThereNonSynchronizedSeeds =
                    await Provider.of<SeedProvider>(context, listen: false)
                        .areThereAnyNonSynchronized();
                if (areThereNonSynchronizedSeeds) {
                  final isLoggingOut = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Sementes não sincronizadas'),
                      content: const Text(
                          'Se você sair agora, perderá as sementes não sincronizadas'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Sair')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('Sincronizar'))
                      ],
                    ),
                  );

                  // TODO Implemet search functionality
                  if (isLoggingOut != null && isLoggingOut) {
                    await Provider.of<SeedProvider>(context, listen: false)
                        .clear();
                    await Provider.of<AuthProvider>(context, listen: false)
                        .logout();
                  }
                } else {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .logout();
                }
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Buscar ...'),
              onChanged: (query) {
                // 2
              },
            ),
          ),
          FutureBuilder(
            future:
                Provider.of<SeedProvider>(context, listen: false).cacheSeeds(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Consumer<SeedProvider>(
                  builder: (context, seedProvider, _) => Expanded(
                    child: ListView.builder(
                      itemCount: seedProvider.seeds.length,
                      itemBuilder: (_, index) {
                        final seed = seedProvider.seeds[index];
                        return Column(
                          children: [
                            ListTile(
                              leading: Text(seed.name),
                              title: Text(seed.manufacturer),
                              trailing: Icon(
                                seed.synchronized == 1
                                    ? Icons.sync
                                    : Icons.sync_disabled,
                                color: seed.synchronized == 1
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
          // const Expanded(
          //   // 3
          //   child: Center(
          //     child: Text('Você não possui sementes'),
          //   ),
          // )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AddNewSeedScreen.routName);
        },
      ),
    );
  }
}
