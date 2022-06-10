import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seed/database/seed_dao.dart';
import 'package:seed/providers/user_provider.dart';
import 'package:seed/providers/seed_provider.dart';
import 'package:seed/repository/user_repository.dart';
import 'package:seed/repository/seed_repository.dart';
import 'package:seed/ui/screens/add_new_seed_screen.dart';
import 'package:seed/ui/screens/data_not_loading_screen.dart';
import 'package:seed/ui/screens/sign_in_screen.dart';
import 'package:seed/ui/screens/seeds_screen.dart';
import 'package:seed/ui/screens/sign_up_screen.dart';

import 'database/database_provider.dart';
import 'database/user_dao.dart';
import 'mappers/standard_seed_mapper.dart';
import 'network/auth_service.dart';
import 'network/seed_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(
            UserRepository(
              AuthService(),
              UserDao(DatabaseProvider.get),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SeedProvider(
            SeedRepository(
              SeedService(),
              UserDao(DatabaseProvider.get),
              SeedDao(DatabaseProvider.get),
              StandardSeedMapper(),
            ),
          ),
        )
      ],
      child: Consumer<UserProvider>(
        builder: (_, authProvider, __) => MaterialApp(
          title: 'Seeder App',
          theme: ThemeData(
            primaryColor: const Color(0xff00c15a),
            fontFamily: 'OpenSans',
            textTheme: const TextTheme(
              headline6: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w900,
              ),
              headline4: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
              button: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w900),
              labelMedium: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          home: FutureBuilder<bool>(
            future: authProvider.isAuthenticated(),
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
          routes: {
            SignInScreen.routeName: (_) => const SignInScreen(),
            SignUpScreen.routeName: (_) => const SignUpScreen(),
            SeedsScreen.routeName: (_) => const SeedsScreen(),
            AddNewSeedScreen.routName: (_) => const AddNewSeedScreen(),
          },
        ),
      ),
    );
  }
}
