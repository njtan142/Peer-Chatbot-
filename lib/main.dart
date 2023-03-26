import 'package:chatbot/authentication/client/login.dart';
import 'package:chatbot/pre_dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'authentication/choose_auth.dart';
import 'firebase/auth.dart';
import 'splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const SplashScreen(),
    );
  }
}

class SessionChecker extends StatefulWidget {
  const SessionChecker({Key? key}) : super(key: key);

  @override
  State<SessionChecker> createState() => _SessionCheckerState();
}

class _SessionCheckerState extends State<SessionChecker> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("Signed in");
          return const PreDashboard();
        } else {
          print("Not signed in");
          return const ClientLoginPage();
        }
      },
    );
  }
}
