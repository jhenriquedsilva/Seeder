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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.green)),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Colors.green, width: 2.0)),
                    hintText: 'Buscar sementes...',
                    hintStyle: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black)
                  ),
                  onChanged: (query) {
                    Provider.of<SeedProvider>(context, listen: false)
                        .searchSeeds(query);
                  },
                ),
              ),
              FutureBuilder(
                future: Provider.of<SeedProvider>(context, listen: false)
                    .cacheSeeds(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );

                    // If a time out exception is thrown
                  } else if (snapshot.hasError) {
                    return Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                snapshot.error.toString(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 24,),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {});
                                },
                                child: Text(
                                  'Recarregar',
                                  style: Theme.of(context).textTheme.button!.copyWith(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                  padding: const EdgeInsets.all(16),
                                  fixedSize: Size(MediaQuery.of(context).size.width * 0.7, 60),
                                  elevation: 16,
                                  shadowColor: Colors.green,
                                  // side: const BorderSide(
                                  //   color: Colors.black,
                                  //   width: 2,
                                  // ),
                                  shape: const StadiumBorder(),
                                )
                              ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // TODO Create a new widget for this list
                    return Consumer<SeedProvider>(
                      builder: (context, seedProvider, _) {
                        if (seedProvider.allSeeds.isEmpty) {
                          return Center(
                            child: Text(
                              'Você ainda não possui sementes. \nComece a registrar',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else {
                          return SingleChildScrollView(
                            child: ExpansionPanelList.radio(
                              children: seedProvider.allSeeds
                                  .map((seed) => ExpansionPanelRadio(
                                      value: seed.id,
                                      canTapOnHeader: true,
                                      headerBuilder: (context, _) => ListTile(
                                            leading: Icon(
                                              Icons.nature,
                                              color: seed.synchronized == 1
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Theme.of(context)
                                                      .errorColor,
                                            ),
                                            title: Text(seed.name),
                                          ),
                                      body: Column(children: [
                                        Row(
                                          children: [
                                            const Text('Fabricado em: '),
                                            Text(seed.manufacturedAt)
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text('Válido até: '),
                                            Text(seed.expiresIn)
                                          ],
                                        )
                                      ])))
                                  .toList(),
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AddNewSeedScreen.routName);
        },
      ),
    );
  }
}
