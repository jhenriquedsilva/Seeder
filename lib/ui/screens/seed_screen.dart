import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        actions: _buildAppBarIconButtons(),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchBox(),
              FutureBuilder(
                future: Provider.of<SeedProvider>(context, listen: false)
                    .cacheSeeds(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    );

                    // If a time out exception is thrown
                  } else if (snapshot.hasError) {
                    return _buildTimeOutExceptionWarning(snapshot);
                  } else {
                    return Expanded(
                      child: Consumer<SeedProvider>(
                        builder: (context, seedProvider, _) {
                          if (seedProvider.allSeeds.isEmpty) {
                            return _buildNoSeedsWarning();
                          } else {
                            return _buildSeedsList(seedProvider);
                          }
                        },
                      ),
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

  List<Widget> _buildAppBarIconButtons() {
    return [
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
                  title: const Text(
                    'Sementes não sincronizadas',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                  content: const Text(
                      'Se você sair agora, perderá as sementes não sincronizadas'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text(
                          'Sair',
                          style: TextStyle(color: Colors.green),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Sincronizar',
                            style: TextStyle(color: Colors.green)))
                  ],
                ),
              );

              if (isLoggingOut != null && isLoggingOut) {
                await Provider.of<SeedProvider>(context, listen: false).clear();
                await Provider.of<AuthProvider>(context, listen: false)
                    .logout();
              }
            } else {
              await Provider.of<AuthProvider>(context, listen: false).logout();
            }
          },
          icon: const Icon(Icons.logout))
    ];
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.green)),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.green, width: 2.0)),
            hintText: 'Buscar sementes...',
            hintStyle: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Colors.black)),
        onChanged: (query) {
          Provider.of<SeedProvider>(context, listen: false).searchSeeds(query);
        },
      ),
    );
  }

  Widget _buildTimeOutExceptionWarning(AsyncSnapshot snapshot) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            snapshot.error.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Colors.black),
          ),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            child: Text(
              'Recarregar',
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(16),
              fixedSize: Size(MediaQuery.of(context).size.width * 0.7, 60),
              elevation: 16,
              shadowColor: Colors.green,
              shape: const StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSeedsWarning() {
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

  Widget _buildSeedsList(SeedProvider seedProvider) {
    return ListView.builder(
      itemCount: seedProvider.allSeeds.length,
      itemBuilder: (context, index) {
        final seed = seedProvider.allSeeds[index];
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
      },
    );
  }
}
