import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../screens/data_not_loading_screen.dart';
import '../screens/seeds_screen.dart';
import '../screens/sign_in_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, userProvider, __) => FutureBuilder<bool>(
        future: userProvider.isAuthenticated(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return DataNotLoadingScreen(
              message: snapshot.error.toString(),
              pressHandler: () {
                setState(() {});
              },
            );
          } else {
            final isAuthenticated = snapshot.data as bool;

            if (isAuthenticated) {
              return const SeedsScreen();
            } else {
              return const SignInScreen();
            }
          }
        },
      ),
    );
  }
}