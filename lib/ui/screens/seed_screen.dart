import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seed/providers/auth_provider.dart';
import 'package:seed/providers/seed_provider.dart';
import 'package:seed/ui/screens/add_new_seed_screen.dart';

class SeedsScreen extends StatefulWidget {
  static const routeName = '/seed';

  const SeedsScreen({Key? key}) : super(key: key);

  @override
  State<SeedsScreen> createState() => _SeedsScreenState();
}

class _SeedsScreenState extends State<SeedsScreen> {
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Sementes',
          style: Theme.of(context).textTheme.headline4,
        ),
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

                  // TODO Implement search functionality
                  // TODO Consider the case when there are no seeds
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
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Buscar sementes...',
              ),
              onChanged: (query) {
                Provider.of<SeedProvider>(context, listen: false).searchSeeds(query);
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

                // If a time out exception is thrown
              } else if (snapshot.hasError) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          snapshot.error.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text(
                            'Recarregar',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        margin: const EdgeInsets.all(16),
                      )
                    ],
                  ),
                );
              } else {
                // TODO Create a new widget for this list
                return Consumer<SeedProvider>(
                  builder: (context, seedProvider, _) => Expanded(
                    child: ListView.builder(
                      itemCount: seedProvider.allSeeds.length,
                      itemBuilder: (_, index) {
                        final seed = seedProvider.allSeeds[index];
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
