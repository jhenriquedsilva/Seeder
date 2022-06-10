import 'package:flutter/material.dart';
import 'package:seed/ui/screens/add_new_seed_screen.dart';
import 'package:seed/ui/widgets/logout_icon_button.dart';
import 'package:seed/ui/widgets/seeds_dashboard.dart';
import 'package:seed/ui/widgets/synchronize_icon_button.dart';

import '../widgets/search_box.dart';

class SeedsScreen extends StatefulWidget {
  static const routeName = '/seeds';

  const SeedsScreen({Key? key}) : super(key: key);

  @override
  State<SeedsScreen> createState() => _SeedsScreenState();
}

class _SeedsScreenState extends State<SeedsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Sementes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          SynchronizeIconButton(
            errorHandler: () {
              setState(() {});
            },
          ),
          const LogoutIconButton()
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Column(
            children: const [
              SearchBox(),
              SeedsDashboard(),
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
