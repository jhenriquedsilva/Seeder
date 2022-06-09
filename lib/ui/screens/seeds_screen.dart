import 'package:flutter/material.dart';
import 'package:seed/ui/screens/add_new_seed_screen.dart';
import 'package:seed/ui/screens/sign_in_screen.dart';

import '../widgets/search_box.dart';

class SeedsScreen extends StatefulWidget {
  static const routeName = '/seeds';

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
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
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
