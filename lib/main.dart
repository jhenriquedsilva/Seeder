import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seed/providers/auth_provider.dart';
import 'package:seed/providers/seed_provider.dart';
import 'package:seed/ui/screens/add_new_seed_screen.dart';
import 'package:seed/ui/screens/sign_in_sign_up_screen.dart';
import 'package:seed/ui/screens/seed_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SeedProvider())
      ],
      child: Consumer<AuthProvider>(
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
              button: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900),
              labelMedium: TextStyle(color: Colors.white, fontSize: 16,)

            ),
          ),
          home: FutureBuilder<bool>(
            future: authProvider.isAuthenticated(),
            builder: (context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  // TODO Create a splash screen
                  child: CircularProgressIndicator(),
                );
              } else {
                final isAuthenticated = snapshot.data as bool;

                if (isAuthenticated) {
                  return const SeedsScreen();
                } else {
                  return const SingInSignUpScreen();
                }
              }
            },
          ),
          routes: {
            AddNewSeedScreen.routName: (_) => const AddNewSeedScreen()
          },
        ),
      ),
    );
  }
}
