import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seed/database/seed_dao.dart';
import 'package:seed/providers/user_provider.dart';
import 'package:seed/providers/seed_provider.dart';
import 'package:seed/repository/user_repository.dart';
import 'package:seed/repository/seed_repository.dart';
import 'package:seed/ui/screens/add_new_seed_screen.dart';
import 'package:seed/ui/screens/sign_in_screen.dart';
import 'package:seed/ui/screens/seeds_screen.dart';
import 'package:seed/ui/screens/sign_up_screen.dart';
import 'package:seed/ui/widgets/home.dart';

import 'database/database_provider.dart';
import 'database/user_dao.dart';
import 'mappers/standard_seed_mapper.dart';
import 'network/user_http_service.dart';
import 'network/seed_http_service.dart';

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
      child: MaterialApp(
          title: 'Seeder App',
          theme: ThemeData(
            primaryColor: const Color(0xff00c15a),
            fontFamily: 'OpenSans',
          ),
          home: const Home(),
          routes: {
            SignInScreen.routeName: (_) => const SignInScreen(),
            SignUpScreen.routeName: (_) => const SignUpScreen(),
            SeedsScreen.routeName: (_) => const SeedsScreen(),
            AddNewSeedScreen.routName: (_) => const AddNewSeedScreen(),
          },
        ),
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(
            UserRepository(
              UserHttpService(),
              UserDao(DatabaseProvider.get),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SeedProvider(
            SeedRepository(
              SeedHttpService(),
              UserDao(DatabaseProvider.get),
              SeedDao(DatabaseProvider.get),
              StandardSeedMapper(),
            ),
          ),
        )
      ],
    );
  }
}

