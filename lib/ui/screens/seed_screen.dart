import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seed/providers/auth_provider.dart';
import 'package:seed/providers/seed_provider.dart';

enum DropDownMenuAction { logout }

class SeedsScreen extends StatelessWidget {
  static const routeName = '/seed';

  const SeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sementes'),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                value: DropDownMenuAction.logout,
                child: Row(
                  children: const [
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Sair')
                  ],
                ),
              )
            ],
            onChanged: (itemId) {
              if (itemId == DropDownMenuAction.logout) {
                Provider.of<AuthProvider>(context, listen: false).logout();
                Provider.of<AuthProvider>(context, listen: false)
                    .changeToLoginMode();
              }
            },
          )
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
                Provider.of<SeedProvider>(context, listen: false).getSeeds(),
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

        },
      ),
    );
  }
}
