import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seed/providers/authentication_provider.dart';
import 'package:seed/ui/screens/sign_in_sign_up_screen.dart';
import 'package:seed/ui/screens/seed_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<String?> _getUserIdFromSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: _getUserIdFromSharedPreference(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data == null) {
                return const SingInSignUpScreen();
              } else {
                final userId = snapshot.data as String;
                return SeedScreen(userId);
              }
            }
          },
        ),
      ),
    );
  }
}
